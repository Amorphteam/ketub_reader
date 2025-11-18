import 'package:freezed_annotation/freezed_annotation.dart';
import '../models/bookmark_models.dart';

part 'bookmark_state.freezed.dart';

@freezed
class BookmarkState with _$BookmarkState {
  const factory BookmarkState.initial({
    @Default(BookmarkSegment.bookmark) BookmarkSegment selectedSegment,
  }) = _Initial;
  
  const factory BookmarkState.loading({
    @Default(BookmarkSegment.bookmark) BookmarkSegment selectedSegment,
  }) = _Loading;
  
  const factory BookmarkState.bookmarksLoaded({
    required List<Bookmark> bookmarks,
    @Default(BookmarkSegment.bookmark) BookmarkSegment selectedSegment,
  }) = _BookmarksLoaded;
  
  const factory BookmarkState.historyLoaded({
    required List<History> history,
    @Default(BookmarkSegment.history) BookmarkSegment selectedSegment,
  }) = _HistoryLoaded;
  
  const factory BookmarkState.bookmarkTapped({
    required Bookmark bookmark,
    @Default(BookmarkSegment.bookmark) BookmarkSegment selectedSegment,
  }) = _BookmarkTapped;
  
  const factory BookmarkState.historyTapped({
    required History history,
    @Default(BookmarkSegment.history) BookmarkSegment selectedSegment,
  }) = _HistoryTapped;
  
  const factory BookmarkState.showClearDialog({
    required BookmarkSegment segment,
    @Default(BookmarkSegment.bookmark) BookmarkSegment selectedSegment,
  }) = _ShowClearDialog;
  
  const factory BookmarkState.error({
    required String message,
    @Default(BookmarkSegment.bookmark) BookmarkSegment selectedSegment,
  }) = _Error;
}

