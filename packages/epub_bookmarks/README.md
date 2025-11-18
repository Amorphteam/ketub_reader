# EPUB Bookmarks

A reusable bookmark and history management package for EPUB reader applications.

## Features

- 📖 Bookmark management (add, delete, clear all)
- 📜 Reading history tracking
- 🔄 Segment switching (bookmarks/history)
- 🎨 Customizable UI (AppBar, empty messages, dialog texts)
- 🔌 Interface-based architecture (easy to integrate)

## Installation

```yaml
dependencies:
  epub_bookmarks:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: epub_bookmarks-v0.1.0
      path: packages/epub_bookmarks
```

## Usage

### 1. Implement Data Sources

```dart
class MyBookmarkDataSource implements BookmarkDataSource {
  @override
  Future<List<Bookmark>> getAllBookmarks() async {
    // Your implementation
  }

  @override
  Future<void> deleteBookmark(int id) async {
    // Your implementation
  }

  @override
  Future<void> clearAllBookmarks() async {
    // Your implementation
  }

  @override
  Future<bool> isBookmarked(String bookPath, String pageIndex) async {
    // Your implementation
  }

  @override
  Future<List<Bookmark>> filterBookmarks(String query) async {
    // Your implementation
  }
}

class MyHistoryDataSource implements HistoryDataSource {
  @override
  Future<List<History>> getAllHistory() async {
    // Your implementation
  }

  @override
  Future<void> deleteHistory(int id) async {
    // Your implementation
  }

  @override
  Future<void> clearAllHistory() async {
    // Your implementation
  }
}
```

### 2. Create Persistence Container

```dart
final persistence = BookmarkPersistence(
  bookmarkDataSource: MyBookmarkDataSource(),
  historyDataSource: MyHistoryDataSource(),
);
```

### 3. Use the Screen

```dart
BookmarkScreen(
  persistence: persistence,
  appBar: CustomAppBar(...), // Optional
  onBookmarkTap: (bookmark) {
    // Navigate to EPUB viewer
    Navigator.pushNamed(context, '/epubViewer', arguments: {
      'reference': bookmark,
    });
  },
  onHistoryTap: (history) {
    // Navigate to EPUB viewer
    Navigator.pushNamed(context, '/epubViewer', arguments: {
      'history': history,
    });
  },
)
```

## Customization

All text strings are customizable:

```dart
BookmarkScreen(
  persistence: persistence,
  emptyBookmarkTitle: 'No bookmarks',
  emptyBookmarkSubtitle: 'Add bookmarks while reading',
  emptyHistoryTitle: 'No history',
  emptyHistorySubtitle: 'Your reading history will appear here',
  clearDialogTitle: 'Confirm Delete',
  clearDialogContent: 'Are you sure?',
  clearDialogCancelText: 'Cancel',
  clearDialogConfirmText: 'Delete',
)
```

## Architecture

Similar to `epub_viewer`, this package uses:
- **Interfaces** for data sources (easy to mock/test)
- **Callbacks** for navigation (no hard dependencies)
- **Configurable UI** (customize as needed)

## License

[Add your license here]

