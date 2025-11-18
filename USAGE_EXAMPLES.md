# Package Usage Examples

## Repository
**GitHub**: `https://github.com/Amorphteam/ketub_reader.git`

---

## 1. Using Only `epub_viewer`

If you only need the EPUB viewer functionality:

```yaml
dependencies:
  epub_viewer:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: epub_viewer-v0.1.0  # Use the latest tag
      path: packages/epub_viewer
```

### Implementation Example:

```dart
import 'package:epub_viewer/epub_viewer.dart';

// In your route_generator.dart or similar
class _BookmarkDataSource implements epub_viewer.BookmarkDataSource {
  // Your implementation
}

class _HistoryDataSource implements epub_viewer.HistoryDataSource {
  // Your implementation
}

// Use the screen
EpubViewerScreenV2(
  entryData: entryData,
  persistence: EpubViewerPersistence(
    bookmarkDataSource: _BookmarkDataSource(),
    historyDataSource: _HistoryDataSource(),
    searchService: DefaultSearchService(),
    pageProgressStore: _PageProgressStore(),
  ),
)
```

---

## 2. Using Only `epub_bookmarks`

If you only need bookmark/history management:

```yaml
dependencies:
  epub_bookmarks:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: epub_bookmarks-v0.1.0  # Use the latest tag
      path: packages/epub_bookmarks
```

### Implementation Example:

```dart
import 'package:epub_bookmarks/epub_bookmarks.dart';

// In your route_generator.dart or similar
class _AppBookmarkDataSource implements BookmarkDataSource {
  // Your implementation
}

class _AppHistoryDataSource implements HistoryDataSource {
  // Your implementation
}

// Use the screen
BookmarkScreen(
  persistence: BookmarkPersistence(
    bookmarkDataSource: _AppBookmarkDataSource(),
    historyDataSource: _AppHistoryDataSource(),
  ),
  onBookmarkTap: (context, bookmark) async {
    // Navigate to EPUB viewer
  },
  onHistoryTap: (context, history) async {
    // Navigate to EPUB viewer
  },
)
```

---

## 3. Using Both Packages

If you want both EPUB viewer and bookmark management:

```yaml
dependencies:
  epub_viewer:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: epub_viewer-v0.1.0
      path: packages/epub_viewer
  
  epub_bookmarks:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: epub_bookmarks-v0.1.0
      path: packages/epub_bookmarks
```

### Implementation Example:

```dart
import 'package:epub_viewer/epub_viewer.dart' as epub_viewer;
import 'package:epub_bookmarks/epub_bookmarks.dart';

// Implement interfaces for both packages
class _BookmarkDataSource implements epub_viewer.BookmarkDataSource {
  // Implementation for epub_viewer
}

class _AppBookmarkDataSource implements BookmarkDataSource {
  // Implementation for epub_bookmarks
}

// Use epub_viewer
EpubViewerScreenV2(
  entryData: entryData,
  persistence: epub_viewer.EpubViewerPersistence(...),
)

// Use epub_bookmarks
BookmarkScreen(
  persistence: BookmarkPersistence(...),
  onBookmarkTap: (context, bookmark) async {
    // Navigate to epub_viewer
    Navigator.pushNamed(context, '/epubViewer', arguments: {
      'reference': bookmark,
    });
  },
)
```

---

## Notes

- **Independent Packages**: Each package can be used independently
- **Shared Interfaces**: Both use similar interface patterns for easy integration
- **Version Tags**: Use specific version tags (e.g., `epub_viewer-v0.1.0`) for stability
- **Latest Version**: Use `main` branch for latest (not recommended for production)

## Version Tags

Check available tags:
```bash
git ls-remote --tags https://github.com/Amorphteam/ketub_reader.git | grep -E "epub_viewer|epub_bookmarks"
```

