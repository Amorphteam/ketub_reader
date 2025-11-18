import 'bookmark_models.dart';

/// Abstraction over bookmark persistence.
abstract class BookmarkDataSource {
  /// Get all bookmarks
  Future<List<Bookmark>> getAllBookmarks();

  /// Delete a bookmark by ID
  Future<void> deleteBookmark(int id);

  /// Clear all bookmarks
  Future<void> clearAllBookmarks();

  /// Check if a bookmark exists
  Future<bool> isBookmarked(String bookPath, String pageIndex);

  /// Filter bookmarks by query
  Future<List<Bookmark>> filterBookmarks(String query);
}

/// Abstraction over history persistence.
abstract class HistoryDataSource {
  /// Get all history entries
  Future<List<History>> getAllHistory();

  /// Delete a history entry by ID
  Future<void> deleteHistory(int id);

  /// Clear all history
  Future<void> clearAllHistory();
}

/// Container for all persistence dependencies needed by the bookmark cubit.
class BookmarkPersistence {
  const BookmarkPersistence({
    required this.bookmarkDataSource,
    required this.historyDataSource,
  });

  final BookmarkDataSource bookmarkDataSource;
  final HistoryDataSource historyDataSource;
}

