# EPUB Search Package

A Flutter package that provides a complete search UI for searching across multiple EPUB books. The package includes a ready-to-use search screen with book selection, recent searches, and expandable results with "load more" functionality.

## Features

- 🔍 **Global Search**: Search across multiple EPUB books simultaneously
- 📚 **Book Selection**: Select/deselect which books to search in
- 📝 **Recent Searches**: Save and manage recent search terms
- ⚡ **Performance**: Background preloading of EPUB files for faster searches
- 🌐 **Arabic Support**: Includes Arabic text normalization (diacritics removal)
- 🔄 **Progressive Results**: Shows partial results as they're found
- 📄 **Expandable Results**: Expand/collapse results per book with "load more" option

## Installation

Add this package to your `pubspec.yaml`:

```yaml
dependencies:
  epub_search:
    git:
      url: https://github.com/Amorphteam/ketub_reader.git
      ref: v0.0.1-beta  # Use the latest tag
      path: packages/epub_search
```

Then run:
```bash
flutter pub get
```

## Dependencies

This package requires the following dependencies (automatically included):
- `epub_parser: ^3.0.1`
- `html: ^0.15.4`
- `flutter_html: ^3.0.0-beta.2`
- `flutter_bloc: ^8.0.0`

## Setup

### 1. Add EPUB Files to Assets

Add your EPUB files to your Flutter app's assets. Update your `pubspec.yaml`:

```yaml
flutter:
  assets:
    - assets/epub/  # Default path, or customize via assetPathPrefix
      - book1.epub
      - book2.epub
      # ... more EPUB files
```

### 2. Implement Required Interfaces

You need to implement two interfaces and create a persistence wrapper (consistent with `epub_bookmarks` and `epub_viewer` packages):

#### `BookDataSource`

Provides the list of books available for searching:

```dart
import 'package:epub_search/epub_search.dart';

class MyBookDataSource implements BookDataSource {
  @override
  Future<List<Book>> getBooks() async {
    // Return list of books from your database/API/storage
    return [
      Book(
        title: 'Book Title 1',
        author: 'Author Name',
        epub: 'books/book1.epub',  // Path relative to assetPathPrefix
        description: 'Book description',
        image: 'covers/book1.jpg',
        series: [
          Series(
            title: 'Series Title',
            epub: 'books/series1.epub',
            description: 'Series description',
            image: 'covers/series1.jpg',
          ),
        ],
      ),
      Book(
        title: 'Book Title 2',
        author: 'Another Author',
        epub: 'books/book2.epub',
      ),
      // ... more books
    ];
  }
}

// Create persistence container
final persistence = SearchPersistence(
  bookDataSource: MyBookDataSource(),
  recentSearchesDataSource: MyRecentSearchesDataSource(),
);
```

**Important Notes:**
- The `epub` field is **required** and should be the path relative to `assetPathPrefix` (default: `'assets/epub/'`)
- Example: If your EPUB file is at `assets/epub/books/mybook.epub`, set `epub: 'books/mybook.epub'`
- The `Book` class supports nested `Series` for organizing books into series

#### Create Persistence Container

After implementing the interfaces, create a `SearchPersistence` wrapper (similar to `BookmarkPersistence` in `epub_bookmarks`):

```dart
final persistence = SearchPersistence(
  bookDataSource: MyBookDataSource(),
  recentSearchesDataSource: MyRecentSearchesDataSource(),
);
```

#### `RecentSearchesDataSource`

Manages recent search terms (optional but recommended):

```dart
import 'package:epub_search/epub_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class MyRecentSearchesDataSource implements RecentSearchesDataSource {
  static const String _key = 'recent_searches';
  final SharedPreferences _prefs;

  MyRecentSearchesDataSource(this._prefs);

  @override
  Future<List<String>> getRecentSearches() async {
    final String? json = _prefs.getString(_key);
    if (json == null) return [];
    final List<dynamic> decoded = jsonDecode(json);
    return decoded.cast<String>();
  }

  @override
  Future<void> saveRecentSearches(List<String> searches) async {
    await _prefs.setString(_key, jsonEncode(searches));
  }

  @override
  Future<void> addRecentSearch(String term) async {
    final searches = await getRecentSearches();
    final updated = [term, ...searches.where((s) => s != term)];
    final limited = updated.take(10).toList();
    await saveRecentSearches(limited);
  }

  @override
  Future<void> removeRecentSearch(String term) async {
    final searches = await getRecentSearches();
    final updated = searches.where((s) => s != term).toList();
    await saveRecentSearches(updated);
  }
}
```

**Alternative Simple Implementation** (in-memory only):

```dart
class InMemoryRecentSearchesDataSource implements RecentSearchesDataSource {
  final List<String> _searches = [];

  @override
  Future<List<String>> getRecentSearches() async => List.from(_searches);

  @override
  Future<void> saveRecentSearches(List<String> searches) async {
    _searches
      ..clear()
      ..addAll(searches);
  }

  @override
  Future<void> addRecentSearch(String term) async {
    _searches.remove(term);
    _searches.insert(0, term);
    if (_searches.length > 10) _searches.removeLast();
  }

  @override
  Future<void> removeRecentSearch(String term) async {
    _searches.remove(term);
  }
}
```

### 3. Create Persistence Container

Create a `SearchPersistence` object with your data sources:

```dart
import 'package:epub_search/epub_search.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Initialize your data sources
final bookDataSource = MyBookDataSource();
final recentSearchesDataSource = await SharedPreferences.getInstance()
    .then((prefs) => MyRecentSearchesDataSource(prefs));
// Or use in-memory version
// final recentSearchesDataSource = InMemoryRecentSearchesDataSource();

// Create persistence container
final persistence = SearchPersistence(
  bookDataSource: bookDataSource,
  recentSearchesDataSource: recentSearchesDataSource,
);
```

### 4. Use the Search Screen

Navigate to the `SearchScreen` widget:

```dart
import 'package:flutter/material.dart';
import 'package:epub_search/epub_search.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: _SearchExample(),
      ),
    );
  }
}

class _SearchExample extends StatefulWidget {
  @override
  _SearchExampleState createState() => _SearchExampleState();
}

class _SearchExampleState extends State<_SearchExample> {
  late SearchPersistence _persistence;

  @override
  void initState() {
    super.initState();
    // Initialize persistence
    _initializePersistence();
  }

  Future<void> _initializePersistence() async {
    final bookDataSource = MyBookDataSource();
    final prefs = await SharedPreferences.getInstance();
    final recentSearchesDataSource = MyRecentSearchesDataSource(prefs);
    
    setState(() {
      _persistence = SearchPersistence(
        bookDataSource: bookDataSource,
        recentSearchesDataSource: recentSearchesDataSource,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_persistence == null) {
      return const Center(child: CircularProgressIndicator());
    }
    
    return SearchScreen(
      persistence: _persistence,
      title: 'البحث العام',  // Custom title (default: "البحث العام")
      assetPathPrefix: 'assets/epub/',  // Default, customize if needed
      onResultTap: (SearchModel result) {
        // Handle when user taps on a search result
        print('Book: ${result.bookTitle}');
        print('Page: ${result.pageIndex}');
        print('Searched word: ${result.searchedWord}');
        
        // Navigate to your EPUB viewer
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => YourEpubViewer(
              epubPath: result.bookAddress!,
              initialPage: result.pageIndex,
            ),
          ),
        );
      },
    );
  }
}
```

## SearchScreen Parameters

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `persistence` | `SearchPersistence` | ✅ Yes | - | Container with book and recent searches data sources |
| `onResultTap` | `OnSearchResultTap?` | ❌ No | `null` | Callback when user taps a search result |
| `title` | `String` | ❌ No | `"البحث العام"` | Screen title |
| `assetPathPrefix` | `String` | ❌ No | `'assets/epub/'` | Prefix path for EPUB files in assets |

## SearchModel Fields

When `onResultTap` is called, you receive a `SearchModel` with:

- `bookAddress` (`String?`): Path to the EPUB file (relative to `assetPathPrefix`)
- `bookTitle` (`String?`): Title of the book
- `searchedWord` (`String?`): The search term that matched
- `pageIndex` (`int`): Page/chapter index (1-based) where the match was found
- `pageId` (`String?`): EPUB page/chapter ID
- `spanna` (`String?`): HTML snippet showing context with highlighted match
- `searchCount` (`int`): Sequential number of this result

## Design Pattern: Persistence Wrapper

This package follows the same design pattern as `epub_bookmarks` and `epub_viewer` packages, using a persistence wrapper class (`SearchPersistence`) to group related data sources together. This provides:

- **Consistency**: Same pattern across all packages
- **Cleaner API**: Single parameter instead of multiple data sources
- **Easier Dependency Management**: All persistence dependencies in one place
- **Better Testability**: Mock entire persistence object for testing

## How It Works

1. **Book Loading**: The package loads all selected EPUB files in the background for faster searching
2. **Search Process**: 
   - Searches are performed in isolate threads for better performance
   - Results are streamed progressively as they're found
   - Arabic text is normalized (diacritics removed) for better matching
3. **Results Display**:
   - Results are grouped by book
   - Each book section can be expanded/collapsed
   - Shows initial 10 results per book (configurable)
   - "Load More" button appears when there are more results
4. **Caching**: Parsed EPUB files are cached in memory for faster subsequent searches

## Asset Path Configuration

The package expects EPUB files to be loaded via Flutter's asset system (`rootBundle.load()`).

**Example Structure:**
```
your_app/
  pubspec.yaml
  lib/
  assets/
    epub/              # This is the default assetPathPrefix
      books/
        book1.epub
        book2.epub
      series/
        series1.epub
```

**In your BookDataSource:**
```dart
Book(
  title: 'My Book',
  epub: 'books/book1.epub',  // Relative to assets/epub/
)
```

**If you customize assetPathPrefix:**
```dart
SearchScreen(
  assetPathPrefix: 'assets/my_epub_files/',
  // ...
)

// Then in BookDataSource:
Book(
  epub: 'my_book.epub',  // Relative to assets/my_epub_files/
)
```

## Integration with EPUB Viewer

To integrate with the `epub_viewer` package:

```dart
import 'package:epub_search/epub_search.dart';
import 'package:epub_viewer/epub_viewer.dart' as epub_viewer;

final persistence = SearchPersistence(
  bookDataSource: MyBookDataSource(),
  recentSearchesDataSource: MyRecentSearchesDataSource(),
);

SearchScreen(
  persistence: persistence,
  onResultTap: (SearchModel result) async {
    // Create entry data for epub_viewer
    final entryData = epub_viewer.EpubViewerEntryData(
      epubPath: result.bookAddress!,
      // Add other required fields
    );

    // Navigate to viewer at the specific page
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => epub_viewer.EpubViewerScreenV2(
          entryData: entryData,
          // Initialize at the result page
          // (epub_viewer should support initialPage parameter)
        ),
      ),
    );
  },
)
```

## Advanced Usage

### Custom Book Selection

The package automatically provides a book selection sheet via the filter icon in the app bar. Users can select/deselect books before searching.

### Preloading Books

The package automatically preloads selected books in the background. You can also manually trigger preloading:

```dart
// Access the cubit and preload manually
final cubit = SearchCubit(
  bookDataSource: _bookDataSource,
  recentSearchesDataSource: _recentSearchesDataSource,
);
await cubit.fetchBooksList();
cubit.preloadSelectedBooks();
```

### Customizing Search Limits

The default search limit is 10 results per book. You can customize this when calling search programmatically:

```dart
// In SearchCubit
await cubit.search('search term', maxResultsPerBook: 20);
```

## Troubleshooting

### EPUB Files Not Found

- Ensure EPUB files are listed in `pubspec.yaml` under `flutter.assets`
- Check that the `epub` path in `Book` matches the actual file location
- Verify `assetPathPrefix` is correct (default: `'assets/epub/'`)

### No Search Results

- Verify EPUB files are valid and can be parsed
- Check that books are selected in the book selection sheet
- Ensure search terms match text content in EPUB files
- For Arabic text, the package normalizes diacritics automatically

### Performance Issues

- The package preloads EPUBs automatically, but first search might be slower
- Large EPUB files may take longer to parse
- Consider limiting `maxResultsPerBook` for faster initial results

## Example Implementation

See [USAGE_EXAMPLES.md](../../USAGE_EXAMPLES.md) in the root of this repository for complete implementation examples.

## License

This package is part of the ketub_reader monorepo. See the repository for license information.

