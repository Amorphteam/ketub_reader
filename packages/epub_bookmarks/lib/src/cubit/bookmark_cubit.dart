import 'package:bloc/bloc.dart';
import '../models/bookmark_models.dart';
import '../models/bookmark_persistence.dart';
import 'bookmark_state.dart';

class BookmarkCubit extends Cubit<BookmarkState> {
  BookmarkCubit({
    required BookmarkPersistence persistence,
  })  : _persistence = persistence,
        super(const BookmarkState.initial()) {
    // Load initial data based on selected segment
    _loadCurrentSegment();
  }

  final BookmarkPersistence _persistence;

  /// Track current segment to avoid losing it during state transitions
  BookmarkSegment _currentSegmentValue = BookmarkSegment.bookmark;

  /// Get current selected segment from state or cached value
  BookmarkSegment get _currentSegment {
    final segmentFromState = state.maybeWhen(
      initial: (segment) => segment,
      loading: (segment) => segment,
      bookmarksLoaded: (_, segment) => segment,
      historyLoaded: (_, segment) => segment,
      bookmarkTapped: (_, segment) => segment,
      historyTapped: (_, segment) => segment,
      showClearDialog: (segment, selectedSeg) => selectedSeg,
      error: (_, segment) => segment,
      orElse: () => _currentSegmentValue,
    );
    _currentSegmentValue = segmentFromState;
    return segmentFromState;
  }

  /// Switch between bookmark and history segments
  void switchSegment(BookmarkSegment segment) {
    if (_currentSegment == segment) return;
    
    _currentSegmentValue = segment;
    
    final newState = state.maybeWhen(
      initial: (_) => BookmarkState.initial(selectedSegment: segment),
      loading: (_) => BookmarkState.loading(selectedSegment: segment),
      bookmarksLoaded: (bookmarks, _) => BookmarkState.bookmarksLoaded(
        bookmarks: bookmarks,
        selectedSegment: segment,
      ),
      historyLoaded: (history, _) => BookmarkState.historyLoaded(
        history: history,
        selectedSegment: segment,
      ),
      error: (message, _) => BookmarkState.error(
        message: message,
        selectedSegment: segment,
      ),
      orElse: () => BookmarkState.initial(selectedSegment: segment),
    );
    
    emit(newState);
    _loadCurrentSegment();
  }

  /// Load data for the currently selected segment
  Future<void> _loadCurrentSegment() async {
    if (_currentSegment == BookmarkSegment.bookmark) {
      await loadAllBookmarks();
    } else {
      await loadAllHistory();
    }
  }

  /// Load all bookmarks
  Future<void> loadAllBookmarks() async {
    final segment = _currentSegment;
    emit(BookmarkState.loading(selectedSegment: segment));
    try {
      final bookmarks = await _persistence.bookmarkDataSource.getAllBookmarks();
      emit(BookmarkState.bookmarksLoaded(
        bookmarks: bookmarks,
        selectedSegment: segment,
      ));
    } catch (error) {
      emit(BookmarkState.error(
        message: error.toString(),
        selectedSegment: segment,
      ));
    }
  }

  /// Load all history
  Future<void> loadAllHistory() async {
    final segment = _currentSegment;
    emit(BookmarkState.loading(selectedSegment: segment));
    try {
      final history = await _persistence.historyDataSource.getAllHistory();
      emit(BookmarkState.historyLoaded(
        history: history,
        selectedSegment: segment,
      ));
    } catch (error) {
      emit(BookmarkState.error(
        message: error.toString(),
        selectedSegment: segment,
      ));
    }
  }

  /// Show clear confirmation dialog
  void showClearDialog() {
    emit(BookmarkState.showClearDialog(
      segment: _currentSegment,
      selectedSegment: _currentSegment,
    ));
  }

  /// Dismiss clear dialog
  void dismissClearDialog() {
    // Return to previous state without dialog - reload current segment data
    final segment = _currentSegment;
    if (segment == BookmarkSegment.bookmark) {
      loadAllBookmarks();
    } else {
      loadAllHistory();
    }
  }

  /// Clear all bookmarks after confirmation
  Future<void> clearAllBookmarks() async {
    final segment = _currentSegment;
    emit(BookmarkState.loading(selectedSegment: segment));
    try {
      await _persistence.bookmarkDataSource.clearAllBookmarks();
      // Load empty list directly to maintain segment
      final bookmarks = await _persistence.bookmarkDataSource.getAllBookmarks();
      emit(BookmarkState.bookmarksLoaded(
        bookmarks: bookmarks,
        selectedSegment: segment,
      ));
    } catch (error) {
      emit(BookmarkState.error(
        message: error.toString(),
        selectedSegment: segment,
      ));
    }
  }

  /// Clear all history after confirmation
  Future<void> clearAllHistory() async {
    final segment = _currentSegment;
    emit(BookmarkState.loading(selectedSegment: segment));
    try {
      await _persistence.historyDataSource.clearAllHistory();
      // Load empty list directly to maintain segment
      final history = await _persistence.historyDataSource.getAllHistory();
      emit(BookmarkState.historyLoaded(
        history: history,
        selectedSegment: segment,
      ));
    } catch (error) {
      emit(BookmarkState.error(
        message: error.toString(),
        selectedSegment: segment,
      ));
    }
  }

  /// Clear all items for current segment
  Future<void> clearAll() async {
    if (_currentSegment == BookmarkSegment.bookmark) {
      await clearAllBookmarks();
    } else {
      await clearAllHistory();
    }
  }

  /// Delete a bookmark
  Future<void> deleteBookmark(int id) async {
    final segment = _currentSegment;
    emit(BookmarkState.loading(selectedSegment: segment));
    try {
      await _persistence.bookmarkDataSource.deleteBookmark(id);
      await loadAllBookmarks();
    } catch (error) {
      emit(BookmarkState.error(
        message: error.toString(),
        selectedSegment: segment,
      ));
    }
  }

  /// Delete a history entry
  Future<void> deleteHistory(int id) async {
    final segment = _currentSegment;
    emit(BookmarkState.loading(selectedSegment: segment));
    try {
      await _persistence.historyDataSource.deleteHistory(id);
      await loadAllHistory();
    } catch (error) {
      emit(BookmarkState.error(
        message: error.toString(),
        selectedSegment: segment,
      ));
    }
  }

  /// Delete item for current segment
  Future<void> deleteItem(int id) async {
    if (_currentSegment == BookmarkSegment.bookmark) {
      await deleteBookmark(id);
    } else {
      await deleteHistory(id);
    }
  }

  /// Filter bookmarks by query
  Future<void> filterBookmarks(String query) async {
    final segment = _currentSegment;
    emit(BookmarkState.loading(selectedSegment: segment));
    try {
      final filteredBookmarks = await _persistence.bookmarkDataSource.filterBookmarks(query);
      emit(BookmarkState.bookmarksLoaded(
        bookmarks: filteredBookmarks,
        selectedSegment: segment,
      ));
    } catch (error) {
      emit(BookmarkState.error(
        message: error.toString(),
        selectedSegment: segment,
      ));
    }
  }

  /// Open EPUB from bookmark
  void openEpubFromBookmark(Bookmark bookmark) {
    emit(BookmarkState.bookmarkTapped(
      bookmark: bookmark,
      selectedSegment: _currentSegment,
    ));
  }

  /// Open EPUB from history
  void openEpubFromHistory(History history) {
    emit(BookmarkState.historyTapped(
      history: history,
      selectedSegment: _currentSegment,
    ));
  }

  /// Refresh current segment data
  Future<void> refresh() async {
    await _loadCurrentSegment();
  }

  /// Dismiss navigation state and return to current segment
  void dismissNavigation() {
    // Return to the current segment's loaded state
    if (_currentSegment == BookmarkSegment.bookmark) {
      loadAllBookmarks();
    } else {
      loadAllHistory();
    }
  }
}

