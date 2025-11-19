import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'interfaces.dart';
import 'search_app_bar.dart';
import 'search_service.dart';
import 'widgets/book_selection_sheet.dart';
import 'widgets/search_results_widget.dart';

/// Search state using freezed-like pattern
abstract class SearchState {
  const SearchState();
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  const SearchLoading();
}

class SearchLoaded extends SearchState {
  final List<SearchModel> searchResults;
  final bool isRunningSearch;

  const SearchLoaded({
    required this.searchResults,
    required this.isRunningSearch,
  });
}

class SearchLoadedList extends SearchState {
  final List<Book> books;

  const SearchLoadedList(this.books);
}

class SearchError extends SearchState {
  final String error;

  const SearchError(this.error);
}

/// Search Cubit for managing search state
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required this.bookDataSource,
    required this.recentSearchesDataSource,
    this.assetPathPrefix = 'assets/epub/',
  }) : super(const SearchInitial());

  final BookDataSource bookDataSource;
  final RecentSearchesDataSource recentSearchesDataSource;
  final String assetPathPrefix;

  List<String> _allBookPaths = [];
  Map<String, bool> _selectedBooks = {};

  Future<void> fetchBooksList() async {
    final List<Book> books = await bookDataSource.getBooks();

    final Set<String> allPaths = {};
    for (var book in books) {
      if (book.epub.isNotEmpty) {
        allPaths.add(book.epub);
      }
      for (var series in book.series ?? []) {
        if (series.epub.isNotEmpty) {
          allPaths.add(series.epub);
        }
      }
    }

    _allBookPaths = allPaths.toList();
    _selectedBooks = {for (var path in _allBookPaths) path: true};

    emit(SearchLoadedList(books));
    // Note: Preloading is handled by preloadSelectedBooks() called from UI
  }

  void updateSelectedBooks(Map<String, bool> selectedBooks) {
    _selectedBooks = selectedBooks;
  }

  /// Pre-load selected books in the background
  void preloadSelectedBooks() {
    EpubSearchService().preloadBooks(
      bookPaths: _allBookPaths,
      selectedBooks: _selectedBooks,
      assetPathPrefix: assetPathPrefix,
    );
  }

  Map<String, bool> get selectedBooks => _selectedBooks;

  Future<void> search(String searchTerm, {int? maxResultsPerBook}) async {
    try {
      emit(const SearchLoading());
      final Set<SearchModel> uniqueResults = {};

      await EpubSearchService().searchAllBooks(
        bookPaths: _allBookPaths,
        selectedBooks: _selectedBooks,
        searchTerm: searchTerm,
        maxResultsPerBook: maxResultsPerBook,
        onPartialResults: (partialResults) {
          uniqueResults.addAll(partialResults);
          emit(SearchLoaded(
            searchResults: uniqueResults.toList(),
            isRunningSearch: true,
          ));
        },
        assetPathPrefix: assetPathPrefix,
      );

      emit(SearchLoaded(
        searchResults: uniqueResults.toList(),
        isRunningSearch: false,
      ));
    } catch (error) {
      emit(SearchError(error.toString()));
    }
  }

  void resetState() {
    try {
      emit(const SearchInitial());
    } catch (e) {
      // Cubit might be closed, ignore
    }
  }
}

/// Main search screen widget
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
    required this.bookDataSource,
    required this.recentSearchesDataSource,
    this.onResultTap,
    this.title = "البحث العام",
    this.assetPathPrefix = 'assets/epub/',
  }) : super(key: key);

  final BookDataSource bookDataSource;
  final RecentSearchesDataSource recentSearchesDataSource;
  final OnSearchResultTap? onResultTap;
  final String title;
  final String assetPathPrefix;

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late SearchCubit _cubit;
  int _selectedBooksCount = 0;
  Map<String, bool> _globalSelectedBooks = {};
  List<Book> allBooks = [];
  String _currentSearchQuery = '';
  List<String> _recentSearches = [];

  @override
  void initState() {
    super.initState();
    _cubit = SearchCubit(
      bookDataSource: widget.bookDataSource,
      recentSearchesDataSource: widget.recentSearchesDataSource,
      assetPathPrefix: widget.assetPathPrefix,
    );
    _cubit.fetchBooksList().then((_) {
      // After books are loaded, start preloading immediately
      _cubit.preloadSelectedBooks();
    });
    _loadRecentSearches();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: SearchAppBar(
          title: widget.title,
          leftWidget: buildLeftWidget(context),
          recentSearches: _recentSearches,
          onRecentSelected: _onRecentSearchSelected,
          onRecentDelete: _onRecentSearchDeleted,
          onLeftTap: () {
            openBookSelectionSheet(allBooks);
            _cubit.resetState();
          },
          onSubmitted: (query) async {
            _currentSearchQuery = query;
            await _upsertRecentSearch(query);
            await _cubit.search(query, maxResultsPerBook: 10);
          },
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: BlocProvider.value(
              value: _cubit,
              child: BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                if (state is SearchInitial) {
                  return Center(
                    child: Text(
                      'ابدأ البحث',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface),
                    ),
                  );
                } else if (state is SearchLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is SearchLoaded) {
                  if (state.searchResults.isEmpty && !state.isRunningSearch) {
                    final displayQuery =
                        _currentSearchQuery.isEmpty ? '...' : _currentSearchQuery;
                    return Center(
                      child: Text(
                        'لم يتم العثور على'
                            '\n "$displayQuery'
                            '"\n في مجال البحث المحدد',
                        style: Theme.of(context).textTheme.titleLarge,
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  if (state.searchResults.isEmpty && state.isRunningSearch) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return SearchResultsWidget(
                    searchResults: state.searchResults,
                    searchQuery: _currentSearchQuery,
                    onResultTap: widget.onResultTap,
                    assetPathPrefix: widget.assetPathPrefix,
                  );
                } else if (state is SearchLoadedList) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    if (_globalSelectedBooks.isEmpty) {
                      allBooks = state.books;
                      _globalSelectedBooks = Map.from(_cubit.selectedBooks);
                      setState(() {
                        _selectedBooksCount = _globalSelectedBooks.entries
                            .where((entry) => entry.value && entry.key.length > 1)
                            .length;
                      });
                      // Start preloading EPUBs immediately after books are loaded
                      _cubit.preloadSelectedBooks();
                    }
                  });
                  return const SizedBox.shrink();
                } else if (state is SearchError) {
                  return Center(child: Text('Error: ${state.error}'));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _onRecentSearchSelected(String term) async {
    await _upsertRecentSearch(term);
    setState(() {
      _currentSearchQuery = term;
    });
    await _cubit.search(term, maxResultsPerBook: 10);
  }

  void _onRecentSearchDeleted(String term) {
    _removeRecentSearch(term);
  }

  Widget buildLeftWidget(BuildContext context) {
    return IconButton(
      onPressed: () async {
        openBookSelectionSheet(allBooks);
        _cubit.resetState();
      },
      icon: const Icon(Icons.tune_rounded),
    );
  }

  void openBookSelectionSheet(List<Book> books) async {
    final selectedBooks = await showModalBottomSheet<Map<String, bool>>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            minChildSize: 0.25,
            maxChildSize: 1.0,
            builder: (context, scrollController) {
              return BookSelectionSheetWidget(
                scrollController: scrollController,
                books: books,
                initialSelectedBooks: _globalSelectedBooks,
              );
            },
          ),
        );
      },
    );

    if (selectedBooks != null) {
      setState(() {
        _globalSelectedBooks = selectedBooks;
        _selectedBooksCount = selectedBooks.entries
            .where((entry) => entry.value && entry.key.length > 1)
            .length;
      });
      _cubit.updateSelectedBooks(selectedBooks);
      // Preload newly selected books
      _cubit.preloadSelectedBooks();
    }
  }

  Future<void> _loadRecentSearches() async {
    _recentSearches = await widget.recentSearchesDataSource.getRecentSearches();
    if (mounted) setState(() {});
  }

  Future<void> _upsertRecentSearch(String term) async {
    final trimmed = term.trim();
    if (trimmed.isEmpty) return;

    final updated = <String>[
      trimmed,
      ..._recentSearches.where((item) => item != trimmed)
    ];
    final limited = updated.take(10).toList();

    setState(() {
      _recentSearches = limited;
    });

    await widget.recentSearchesDataSource.saveRecentSearches(limited);
  }

  Future<void> _removeRecentSearch(String term) async {
    final updated = _recentSearches.where((item) => item != term).toList();
    setState(() {
      _recentSearches = updated;
    });
    await widget.recentSearchesDataSource.saveRecentSearches(updated);
  }
}
