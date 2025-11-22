import '../interfaces.dart';

/// Container for all persistence dependencies needed by the search cubit.
class SearchPersistence {
  const SearchPersistence({
    required this.bookDataSource,
    required this.recentSearchesDataSource,
  });

  final BookDataSource bookDataSource;
  final RecentSearchesDataSource recentSearchesDataSource;
}

