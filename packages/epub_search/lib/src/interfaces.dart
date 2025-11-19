/// Interfaces for epub_search package
/// 
/// These interfaces allow the package to work with different data sources
/// without depending on specific implementations.

/// Book model for search package
class Book {
  final String? title;
  final String? author;
  final String? description;
  final String? image;
  final String epub;
  final List<Series>? series;

  const Book({
    this.title,
    this.author,
    this.description,
    this.image,
    required this.epub,
    this.series,
  });
}

class Series {
  final String? title;
  final String? description;
  final String? image;
  final String epub;

  const Series({
    this.title,
    this.description,
    this.image,
    required this.epub,
  });
}

/// Search result model
class SearchModel {
  final String? bookAddress;
  final String? bookTitle;
  final String? searchedWord;
  final String? pageId;
  final String? spanna;
  final int pageIndex;
  final int searchCount;

  const SearchModel({
    this.bookAddress,
    this.bookTitle,
    this.searchedWord,
    this.pageId,
    this.spanna,
    required this.pageIndex,
    required this.searchCount,
  });

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SearchModel) return false;
    return bookAddress == other.bookAddress && 
           pageIndex == other.pageIndex && 
           spanna == other.spanna;
  }

  @override
  int get hashCode => Object.hash(bookAddress, pageIndex, spanna);
}

/// Data source for fetching books list
abstract class BookDataSource {
  Future<List<Book>> getBooks();
}

/// Data source for managing recent searches
abstract class RecentSearchesDataSource {
  Future<List<String>> getRecentSearches();
  Future<void> saveRecentSearches(List<String> searches);
  Future<void> addRecentSearch(String term);
  Future<void> removeRecentSearch(String term);
}

/// Callback for when a search result is tapped
typedef OnSearchResultTap = void Function(SearchModel result);

