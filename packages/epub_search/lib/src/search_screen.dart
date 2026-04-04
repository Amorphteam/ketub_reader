import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'interfaces.dart';
import 'models/search_persistence.dart';
import 'widgets/search_app_bar.dart';
import 'widgets/book_selection_sheet.dart';
import 'widgets/search_results_widget.dart';
import 'cubit/search_cubit.dart';
import 'cubit/search_state.dart';

/// Callback to build a fully custom app bar.
///
/// The builder receives a [SearchAppBarConfig] object that exposes the current
/// search UI state and actions (submit, open filter sheet, recent selections).
typedef SearchAppBarBuilder = PreferredSizeWidget Function(
  BuildContext context,
  SearchAppBarConfig config,
);

/// Configuration passed to [SearchAppBarBuilder].
class SearchAppBarConfig {
  const SearchAppBarConfig({
    required this.title,
    required this.backgroundImage,
    required this.showLeftSide,
    required this.showRightSide,
    required this.recentSearches,
    required this.onOpenBookSelection,
    required this.onSubmitted,
    required this.onRecentSelected,
    required this.onRecentDelete,
  });

  final String title;
  final String? backgroundImage;
  final bool showLeftSide;
  final bool showRightSide;
  final List<String> recentSearches;
  final VoidCallback onOpenBookSelection;
  final Future<void> Function(String query) onSubmitted;
  final Future<void> Function(String term) onRecentSelected;
  final void Function(String term) onRecentDelete;
}

/// Main search screen widget
class SearchScreen extends StatefulWidget {
  const SearchScreen({
    Key? key,
    required this.persistence,
    this.onResultTap,
    this.appBarbackground,
    this.title = "البحث العام",
    this.assetPathPrefix = 'assets/epub/',
    this.customAppBar,
    this.customAppBarBuilder,
    this.showLeftAppBarSide = true,
    this.showRightAppBarSide = true,
    this.groupResultsByBookName = true,
    this.resultItemUseCard = false,
    this.showResultPageNumber = true,
    this.resultItemCardColor,
  }) : super(key: key);

  final SearchPersistence persistence;
  final OnSearchResultTap? onResultTap;
  final String title;
  final String assetPathPrefix;
  final String? appBarbackground;
  final PreferredSizeWidget? customAppBar;
  final SearchAppBarBuilder? customAppBarBuilder;
  final bool showLeftAppBarSide;
  final bool showRightAppBarSide;
  final bool groupResultsByBookName;
  /// When true, each hit is shown inside a [Card] instead of a [ListTile] + [Divider].
  final bool resultItemUseCard;
  /// When false, the page index is hidden for each result row.
  final bool showResultPageNumber;
  /// Background for each result [Card] when [resultItemUseCard] is true. Null uses theme default.
  final Color? resultItemCardColor;

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
      persistence: widget.persistence,
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
    final appBarConfig = SearchAppBarConfig(
      title: widget.title,
      backgroundImage: widget.appBarbackground,
      showLeftSide: widget.showLeftAppBarSide,
      showRightSide: widget.showRightAppBarSide,
      recentSearches: _recentSearches,
      onOpenBookSelection: () {
        openBookSelectionSheet(allBooks);
        _cubit.resetState();
      },
      onSubmitted: _handleSubmitted,
      onRecentSelected: _onRecentSearchSelected,
      onRecentDelete: _onRecentSearchDeleted,
    );

    final defaultAppBar = SearchAppBar(
      title: appBarConfig.title,
      backgroundImage: appBarConfig.backgroundImage,
      leftIcon: Icons.tune_rounded,
      recentSearches: appBarConfig.recentSearches,
      onRecentSelected: appBarConfig.onRecentSelected,
      onRecentDelete: appBarConfig.onRecentDelete,
      showLeftSide: appBarConfig.showLeftSide,
      showRightSide: appBarConfig.showRightSide,
      onLeftTap: appBarConfig.onOpenBookSelection,
      onSubmitted: (query) => appBarConfig.onSubmitted(query),
    );

    return Scaffold(
        appBar: widget.customAppBarBuilder?.call(context, appBarConfig) ??
            widget.customAppBar ??
            defaultAppBar,
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
                    groupResultsByBookName: widget.groupResultsByBookName,
                    resultItemUseCard: widget.resultItemUseCard,
                    showResultPageNumber: widget.showResultPageNumber,
                    resultItemCardColor: widget.resultItemCardColor,
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
    await _cubit.search(
      term,
      maxResultsPerBook: widget.groupResultsByBookName ? 10 : null,
    );
  }

  void _onRecentSearchDeleted(String term) {
    _removeRecentSearch(term);
  }

  Future<void> _handleSubmitted(String query) async {
    _currentSearchQuery = query;
    await _upsertRecentSearch(query);
    await _cubit.search(
      query,
      maxResultsPerBook: widget.groupResultsByBookName ? 10 : null,
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
    _recentSearches = await widget.persistence.recentSearchesDataSource.getRecentSearches();
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

    await widget.persistence.recentSearchesDataSource.saveRecentSearches(limited);
  }

  Future<void> _removeRecentSearch(String term) async {
    final updated = _recentSearches.where((item) => item != term).toList();
    setState(() {
      _recentSearches = updated;
    });
    await widget.persistence.recentSearchesDataSource.saveRecentSearches(updated);
  }
}
