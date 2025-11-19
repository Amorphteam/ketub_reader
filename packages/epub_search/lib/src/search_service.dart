import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:epub_parser/epub_parser.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:html/parser.dart' show parse;

import 'interfaces.dart';
import 'epub_helpers.dart';

/// Main service for searching across multiple EPUB books
class EpubSearchService {
  factory EpubSearchService() => _instance;
  EpubSearchService._internal();
  static final EpubSearchService _instance = EpubSearchService._internal();

  bool _isSearchStopped = false;
  // Cache for parsed EPUB books (bookPath -> parsed book data)
  final Map<String, _EpubBookData> _epubCache = {};
  // Track books currently being loaded (bookPath -> Future)
  final Map<String, Future<_EpubBookData>> _loadingBooks = {};

  /// Search across multiple books using book paths and selection map
  Future<void> searchAllBooks({
    required List<String> bookPaths,
    required Map<String, bool> selectedBooks,
    required String searchTerm,
    int? maxResultsPerBook,
    required Function(List<SearchModel>) onPartialResults,
    String assetPathPrefix = 'assets/epub/',
  }) async {
    _isSearchStopped = false;

    final selectedPaths = bookPaths.where((path) => selectedBooks[path] == true).toList();

    if (selectedPaths.isEmpty) {
      onPartialResults([]);
      return;
    }

    final List<_EpubBookData> loadedBooks = await _loadBooksFromPaths(
      selectedPaths,
      assetPathPrefix,
    );

    if (loadedBooks.isEmpty) {
      onPartialResults([]);
      return;
    }

    await _searchAllBooks(
      loadedBooks,
      searchTerm,
      onPartialResults,
      maxResultsPerBook,
    );
  }

  Future<List<_EpubBookData>> _loadBooksFromPaths(
    List<String> bookPaths,
    String assetPathPrefix,
  ) async {
    final List<_EpubBookData> epubBooks = [];
    final List<Future<_EpubBookData>> loadingFutures = [];

    for (final bookPath in bookPaths) {
      // Check cache first
      if (_epubCache.containsKey(bookPath)) {
        epubBooks.add(_epubCache[bookPath]!);
        continue;
      }

      // Check if already loading
      if (_loadingBooks.containsKey(bookPath)) {
        // Wait for the existing load to complete
        final bookData = await _loadingBooks[bookPath]!;
        epubBooks.add(bookData);
        continue;
      }

      // Start loading this book
      final loadFuture = _loadSingleBook(bookPath, assetPathPrefix);
      _loadingBooks[bookPath] = loadFuture;
      loadingFutures.add(loadFuture);
    }

    // Wait for all new loads to complete
    final loadedBooks = await Future.wait(loadingFutures);
    epubBooks.addAll(loadedBooks);

    return epubBooks;
  }

  Future<_EpubBookData> _loadSingleBook(String bookPath, String assetPathPrefix) async {
    try {
      final fullPath = '$assetPathPrefix$bookPath';
      final epubData = await rootBundle.load(fullPath);

      final epubBook = await compute(
        _parseEpubInIsolate,
        epubData.buffer.asUint8List(),
      );

      final bookData = _EpubBookData(epubBook, bookPath);
      // Cache the parsed book
      _epubCache[bookPath] = bookData;
      // Remove from loading map
      _loadingBooks.remove(bookPath);
      return bookData;
    } catch (e) {
      // Remove from loading map on error
      _loadingBooks.remove(bookPath);
      print("❌ Could not load book: $bookPath - Skipping... Error: $e");
      rethrow;
    }
  }

  /// Clear the EPUB cache (useful when books are deselected)
  void clearCache() {
    _epubCache.clear();
  }

  /// Clear cache for specific book paths
  void clearCacheForPaths(List<String> bookPaths) {
    for (final path in bookPaths) {
      _epubCache.remove(path);
    }
  }

  /// Pre-load EPUBs for selected books in the background
  /// This prepares books for faster searching
  /// Returns immediately, loading happens asynchronously
  void preloadBooks({
    required List<String> bookPaths,
    required Map<String, bool> selectedBooks,
    String assetPathPrefix = 'assets/epub/',
  }) {
    final selectedPaths = bookPaths.where((path) => selectedBooks[path] == true).toList();
    
    // Only load books that aren't already cached or currently loading
    final pathsToLoad = selectedPaths.where((path) => 
      !_epubCache.containsKey(path) && !_loadingBooks.containsKey(path)
    ).toList();
    
    if (pathsToLoad.isEmpty) {
      return; // All books already cached or loading
    }

    print("📚 Preloading ${pathsToLoad.length} EPUBs in background...");
    
    // Start loading each book individually and track them
    for (final bookPath in pathsToLoad) {
      final loadFuture = _loadSingleBook(bookPath, assetPathPrefix);
      _loadingBooks[bookPath] = loadFuture;
      
      // Handle completion/error
      loadFuture.then((_) {
        print("✅ Preloaded: $bookPath");
      }).catchError((error) {
        print("⚠️ Error preloading $bookPath: $error");
        _loadingBooks.remove(bookPath);
      });
    }
  }

  Future<void> _searchAllBooks(
    List<_EpubBookData> allBooks,
    String word,
    Function(List<SearchModel>) onPartialResults,
    int? maxResultsPerBook,
  ) async {
    final receivePort = ReceivePort();
    await Isolate.spawn(
      _searchAllBooksIsolate,
      _SearchTask(allBooks, word, receivePort.sendPort, maxResultsPerBook),
    );

    await for (final message in receivePort) {
      if (message is List<SearchModel>) {
        onPartialResults(message);
      } else if (message is String && message == 'done') {
        break;
      } else if (message is SendPort) {
        message.send(null);
      }
    }
  }

  static Future<void> _searchAllBooksIsolate(_SearchTask task) async {
    final port = ReceivePort();
    task.sendPort.send(port.sendPort);

    final List<SearchModel> allResults = [];

    for (final bookData in task.allBooks) {
      final bookName = bookData.epubBook.Title;
      final bookAddress = bookData.bookPath;
      final List<HtmlFileInfo> epubContent =
          await extractHtmlContentWithEmbeddedImages(bookData.epubBook);

      final spineItems = bookData.epubBook.Schema?.Package?.Spine?.Items;
      final List<String> idRefs = [];

      if (spineItems != null) {
        for (final item in spineItems) {
          if (item.IdRef != null) {
            idRefs.add(item.IdRef!);
          }
        }
      }

      final epubNewContent = reorderHtmlFilesBasedOnSpine(epubContent, idRefs);
      final spineHtmlContent =
          epubNewContent.map((info) => info.modifiedHtmlContent).toList();

      final result = await _searchHtmlContents(
        spineHtmlContent,
        task.word,
        bookName,
        bookAddress,
        task.maxResultsPerBook,
      );

      allResults.addAll(result);
      task.sendPort.send(List<SearchModel>.from(allResults));
    }

    task.sendPort.send('done');
  }

  static Future<List<SearchModel>> _searchHtmlContents(
    List<String> htmlContents,
    String searchWord,
    String? bookName,
    String? bookAddress,
    int? maxResultsPerBook,
  ) async {
    final List<SearchModel> results = [];
    final normalizedSearchWord = _removeArabicDiacritics(searchWord);
    int bookResultCount = 0;

    // Match the original implementation: check limit in loop condition
    for (int i = 0;
        i < htmlContents.length &&
            (maxResultsPerBook == null || bookResultCount < maxResultsPerBook);
        i++) {
      final String pageContent = _removeHtmlTags(htmlContents[i]);
      _SearchIndex searchIndex =
          _searchInString(pageContent, normalizedSearchWord, 0);

      while (searchIndex.startIndex >= 0 &&
          (maxResultsPerBook == null || bookResultCount < maxResultsPerBook)) {
        results.add(SearchModel(
          pageIndex: i + 1,
          searchedWord: searchWord,
          searchCount: results.length + 1,
          spanna: _getHighlightedSection(searchIndex, pageContent),
          bookAddress: bookAddress,
          bookTitle: bookName,
        ));

        bookResultCount++;
        if (maxResultsPerBook != null && bookResultCount >= maxResultsPerBook) {
          break;
        }

        searchIndex = _searchInString(
            pageContent, normalizedSearchWord, searchIndex.lastIndex + 1);
      }
    }

    return results;
  }

  static String _removeArabicDiacritics(String text) {
    String normalizedText = text
        .replaceAll('ء', 'ا')
        .replaceAll('ؤ', 'و')
        .replaceAll('ئ', 'ي')
        .replaceAll('آ', 'ا')
        .replaceAll('أ', 'ا')
        .replaceAll('إ', 'ا')
        .replaceAll('ة', 'ه');

    final RegExp diacriticsRegex = RegExp(
      r'[\u064B-\u065F\u0610-\u061A\u06D6-\u06DC\u06DF-\u06E8\u06EA-\u06ED]',
      unicode: true,
    );
    return normalizedText.replaceAll(diacriticsRegex, '');
  }

  static String _getHighlightedSection(_SearchIndex index, String wholeString) {
    final sw = wholeString.substring(index.startIndex, index.lastIndex);
    final lastIndex = wholeString.length;
    final firstCutIndex =
        index.startIndex - 40 > 0 ? index.startIndex - 40 : 0;
    final lastCutIndex = index.lastIndex + 40 > lastIndex
        ? lastIndex
        : index.lastIndex + 40;
    final surr1 = '...${wholeString.substring(firstCutIndex, index.startIndex)}';
    final surr2 = '${wholeString.substring(index.lastIndex, lastCutIndex)}...';
    return '$surr1<mark>$sw</mark>$surr2';
  }

  static _SearchIndex _searchInString(String pageString, String sw, int start) {
    final normalizedPage = _removeArabicDiacritics(pageString);
    final normalizedSearchWord = _removeArabicDiacritics(sw);

    final startIndex = normalizedPage.indexOf(normalizedSearchWord, start);
    return startIndex >= 0
        ? _SearchIndex(startIndex, startIndex + normalizedSearchWord.length)
        : _SearchIndex(-1, -1);
  }

  static String _removeHtmlTags(String htmlString) {
    final text = parse(htmlString).documentElement!.text;
    return _removeArabicDiacritics(text);
  }

  /// Search a single book by path without result limits
  /// Used for "load more" functionality
  Future<List<SearchModel>> searchSingleBook({
    required String bookPath,
    required String searchTerm,
    String assetPathPrefix = 'assets/epub/',
  }) async {
    try {
      EpubBook epubBook;
      
      // Check cache first
      if (_epubCache.containsKey(bookPath)) {
        epubBook = _epubCache[bookPath]!.epubBook;
      } else {
        final fullPath = '$assetPathPrefix$bookPath';
        final epubData = await rootBundle.load(fullPath);
        epubBook = await compute(_parseEpubInIsolate, epubData.buffer.asUint8List());
        // Cache it for future use
        _epubCache[bookPath] = _EpubBookData(epubBook, bookPath);
      }

      final List<HtmlFileInfo> epubContent = await extractHtmlContentWithEmbeddedImages(epubBook);

      final spineItems = epubBook.Schema?.Package?.Spine?.Items;
      final List<String> idRefs = [];

      if (spineItems != null) {
        for (final item in spineItems) {
          if (item.IdRef != null) {
            idRefs.add(item.IdRef!);
          }
        }
      }

      final epubNewContent = reorderHtmlFilesBasedOnSpine(epubContent, idRefs);
      final spineHtmlContent = epubNewContent.map((info) => info.modifiedHtmlContent).toList();

      // Search without limits (maxResultsPerBook = null)
      return await _searchHtmlContents(
        spineHtmlContent,
        searchTerm,
        epubBook.Title,
        bookPath,
        null, // No limit
      );
    } catch (e) {
      print("❌ Error searching book: $bookPath - Error: $e");
      return [];
    }
  }

  Future<void> stopSearch(bool stop) async {
    _isSearchStopped = stop;
  }
}

// Internal helper classes
class _EpubBookData {
  final EpubBook epubBook;
  final String bookPath;

  _EpubBookData(this.epubBook, this.bookPath);
}

class _SearchIndex {
  final int startIndex;
  final int lastIndex;

  _SearchIndex(this.startIndex, this.lastIndex);
}

class _SearchTask {
  final List<_EpubBookData> allBooks;
  final String word;
  final SendPort sendPort;
  final int? maxResultsPerBook;

  _SearchTask(this.allBooks, this.word, this.sendPort, [this.maxResultsPerBook]);
}

Future<EpubBook> _parseEpubInIsolate(Uint8List bytes) async {
  return await EpubReader.readBook(bytes);
}

