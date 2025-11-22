import 'package:flutter_bloc/flutter_bloc.dart';
import '../interfaces.dart';
import '../models/search_persistence.dart';
import '../search_service.dart';
import 'search_state.dart';

/// Search Cubit for managing search state
class SearchCubit extends Cubit<SearchState> {
  SearchCubit({
    required SearchPersistence persistence,
    this.assetPathPrefix = 'assets/epub/',
  })  : _persistence = persistence,
        super(const SearchInitial());

  final SearchPersistence _persistence;
  final String assetPathPrefix;

  List<String> _allBookPaths = [];
  Map<String, bool> _selectedBooks = {};

  Future<void> fetchBooksList() async {
    final List<Book> books = await _persistence.bookDataSource.getBooks();

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

