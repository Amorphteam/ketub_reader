import 'package:freezed_annotation/freezed_annotation.dart';

part 'bookmark_models.freezed.dart';

/// Represents a bookmark entry.
@freezed
class Bookmark with _$Bookmark {
  const factory Bookmark({
    int? id,
    required String title,
    required String bookName,
    required String bookPath,
    required String pageIndex,
    String? fileName,
  }) = _Bookmark;
}

/// Represents a history entry.
@freezed
class History with _$History {
  const factory History({
    int? id,
    required String title,
    required String bookName,
    required String bookPath,
    required String pageIndex,
  }) = _History;
}

/// Enum for bookmark screen segments
enum BookmarkSegment { bookmark, history }

