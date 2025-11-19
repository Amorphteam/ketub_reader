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
      ref: v0.0.1-beta  # Shared repo tag; run `git tag` to confirm latest
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
      ref: v0.0.1-beta  # Same tag works for all packages
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
      ref: v0.0.1-beta
      path: packages/epub_viewer
  
  epub_bookmarks:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: v0.0.1-beta
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

## 4. Using Only `epub_search`

If you want the standalone global search UI:

```yaml
dependencies:
  epub_search:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: v0.0.1-beta
      path: packages/epub_search
```

### Implementation Example:

```dart
import 'package:epub_search/epub_search.dart';

class _BookRepo implements BookDataSource {
  @override
  Future<List<Book>> getBooks() async {
    return const [
      Book(title: 'Sample Book', epub: 'books/sample.epub'),
    ];
  }
}

class _RecentSearchStore implements RecentSearchesDataSource {
  final _cache = <String>[];

  @override
  Future<List<String>> getRecentSearches() async => _cache;

  @override
  Future<void> saveRecentSearches(List<String> searches) async {
    _cache
      ..clear()
      ..addAll(searches);
  }

  @override
  Future<void> addRecentSearch(String term) async {}

  @override
  Future<void> removeRecentSearch(String term) async {}
}

SearchScreen(
  bookDataSource: _BookRepo(),
  recentSearchesDataSource: _RecentSearchStore(),
  onResultTap: (result) {
    // Navigate to your viewer, passing result.pageIndex
  },
  assetPathPrefix: 'assets/epub/',
);
```

---

## 5. Using All Packages Together

```yaml
dependencies:
  epub_viewer:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: v0.0.1-beta
      path: packages/epub_viewer

  epub_bookmarks:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: v0.0.1-beta
      path: packages/epub_bookmarks

  epub_search:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: v0.0.1-beta
      path: packages/epub_search
```

### Integration Sketch:

- **Viewer ↔ Bookmarks**: reuse your bookmark/history data sources so both packages stay in sync.
- **Viewer ↔ Search**: inside `onResultTap`, push `EpubViewerScreenV2` with the `SearchModel.pageIndex` to deep-link into the EPUB.
- **Search ↔ Bookmarks**: optionally add search results to history or bookmarks when users tap on them for consistent UX.

---

## Notes

- **Independent Packages**: Each package can be used independently
- **Shared Interfaces**: Both use similar interface patterns for easy integration
- **Version Tags**: Use the shared repo tag (e.g., `v0.0.1-beta`) until package-specific tags are published
- **Latest Version**: Use `main` branch for latest (not recommended for production)

## Version Tags

Check available tags:
```bash
git ls-remote --tags https://github.com/Amorphteam/ketub_reader.git
```

