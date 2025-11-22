import '../interfaces.dart';

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

