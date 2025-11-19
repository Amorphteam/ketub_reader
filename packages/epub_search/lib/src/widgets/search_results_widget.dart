import 'package:epub_parser/epub_parser.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter/services.dart';
import '../interfaces.dart';
import '../search_service.dart';
import '../epub_helpers.dart';

const int MAX_RESULTS_PER_BOOK = 10;

class SearchResultsWidget extends StatefulWidget {
  const SearchResultsWidget({
    super.key,
    required this.searchResults,
    required this.searchQuery,
    this.onResultTap,
    this.assetPathPrefix = 'assets/epub/',
  });

  final List<SearchModel> searchResults;
  final String searchQuery;
  final OnSearchResultTap? onResultTap;
  final String assetPathPrefix;

  @override
  _SearchResultsWidgetState createState() => _SearchResultsWidgetState();
}

class _SearchResultsWidgetState extends State<SearchResultsWidget> {
  final Map<String, List<SearchModel>> _expandedResults = {};
  final Map<String, bool> _loadingStates = {};
  final Map<String, int> _totalResultsCount = {};
  final Map<String, int> _lastResultIndex = {};
  final Map<String, bool> _isExpanded = {};
  final Map<String, bool> _hasMoreResults = {};

  Future<void> loadMoreResults(String bookTitle) async {
    if (bookTitle == null) return;

    setState(() {
      _loadingStates[bookTitle] = true;
    });

    try {
      final isFirstLoad = _lastResultIndex[bookTitle] == null;

      if (isFirstLoad) {
        setState(() {
          _expandedResults[bookTitle] = [];
          _lastResultIndex[bookTitle] = 0;
          _totalResultsCount[bookTitle] = 0;
          _hasMoreResults[bookTitle] = true;
        });
      }

      final lastIndex = _lastResultIndex[bookTitle] ?? 0;
      final newResults = await _fetchAllResultsForBook(bookTitle, lastIndex);

      if (newResults.isNotEmpty) {
        setState(() {
          if (_expandedResults[bookTitle] == null) {
            _expandedResults[bookTitle] = [];
          }

          final allResults = [..._expandedResults[bookTitle]!, ...newResults];

          final uniqueResults = <SearchModel>[];
          final seenPageNumbers = <int>{};

          for (final result in allResults) {
            if (!seenPageNumbers.contains(result.pageIndex)) {
              seenPageNumbers.add(result.pageIndex);
              uniqueResults.add(result);
            }
          }

          uniqueResults.sort((a, b) => a.pageIndex.compareTo(b.pageIndex));

          _expandedResults[bookTitle] = uniqueResults;
          _loadingStates[bookTitle] = false;
          _lastResultIndex[bookTitle] = lastIndex + newResults.length;
          _totalResultsCount[bookTitle] = uniqueResults.length;
        });
      } else {
        setState(() {
          _loadingStates[bookTitle] = false;
          _hasMoreResults[bookTitle] = false;
        });
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('تم تحميل جميع النتائج'),
              backgroundColor: Theme.of(context).colorScheme.secondary,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      setState(() {
        _loadingStates[bookTitle] = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('حدث خطأ أثناء تحميل المزيد من النتائج: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<List<SearchModel>> _fetchAllResultsForBook(String bookTitle, int startIndex) async {
    try {
      final bookResult = widget.searchResults.firstWhere(
        (result) => result.bookTitle == bookTitle,
        orElse: () => throw Exception('Book not found'),
      );

      if (bookResult.bookAddress == null) {
        throw Exception('Book address is null');
      }

      // Use the search service to get all results for this book
      final allResults = await EpubSearchService().searchSingleBook(
        bookPath: bookResult.bookAddress!,
        searchTerm: widget.searchQuery,
        assetPathPrefix: widget.assetPathPrefix,
      );

      // Get existing results to avoid duplicates
      final existingResults = [
        ...widget.searchResults.where((r) => r.bookTitle == bookTitle),
        ...(_expandedResults[bookTitle] ?? [])
      ];

      final existingPageNumbers = <int>{};
      for (final result in existingResults) {
        existingPageNumbers.add(result.pageIndex);
      }

      // Filter out duplicates
      final uniqueResults = <SearchModel>[];
      final seenPageNumbers = <int>{};

      for (final result in allResults) {
        if (!existingPageNumbers.contains(result.pageIndex) &&
            !seenPageNumbers.contains(result.pageIndex)) {
          seenPageNumbers.add(result.pageIndex);
          uniqueResults.add(result);
        }
      }

      uniqueResults.sort((a, b) => a.pageIndex.compareTo(b.pageIndex));

      // Get the next 1000 results starting from startIndex
      final nextResults = uniqueResults.skip(startIndex).take(1000).toList();

      if (nextResults.length < 1000) {
        _hasMoreResults[bookTitle] = false;
      }

      return nextResults;
    } catch (e) {
      print('Error searching book: $e');
      rethrow;
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: widget.searchResults.length,
            itemBuilder: (context, index) {
              final currentBookTitle = widget.searchResults[index].bookTitle;
              final isFirstResultOfBook = index == 0 ||
                  widget.searchResults[index].bookTitle !=
                      widget.searchResults[index - 1].bookTitle;
              final isLastResultOfBook = index == widget.searchResults.length - 1 ||
                  widget.searchResults[index].bookTitle !=
                      widget.searchResults[index + 1].bookTitle;
              final expandedResults = _expandedResults[currentBookTitle] ?? [];
              final isLoading = _loadingStates[currentBookTitle] ?? false;
              final initialResultsCount = widget.searchResults
                  .where((result) => result.bookTitle == currentBookTitle)
                  .length;
              final totalResultsCount =
                  _totalResultsCount[currentBookTitle] ?? initialResultsCount;
              final isExpanded = _isExpanded[currentBookTitle] ?? false;
              final shouldShowLoadMore = initialResultsCount >= MAX_RESULTS_PER_BOOK;

              if (isFirstResultOfBook) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Card(
                        color: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 0),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isExpanded[currentBookTitle!] = !isExpanded;
                              });
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    IconButton(
                                      icon: Icon(
                                        isExpanded
                                            ? Icons.expand_less
                                            : Icons.expand_more,
                                        color: Theme.of(context).colorScheme.secondary,
                                      ),
                                      onPressed: () {
                                        setState(() {
                                          _isExpanded[currentBookTitle!] = !isExpanded;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                Expanded(
                                  child: Text(
                                    textAlign: TextAlign.right,
                                    currentBookTitle!,
                                    style: Theme.of(context).textTheme.titleSmall,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    if (isExpanded) ...[
                      ...widget.searchResults
                          .where((result) => result.bookTitle == currentBookTitle)
                          .map((result) => _buildResultList(result))
                          .expand((x) => x),
                      if (expandedResults.isNotEmpty) ...[
                        ...expandedResults
                            .map((result) => _buildResultList(result))
                            .expand((x) => x),
                      ],
                      if (isLastResultOfBook) ...[
                        if (shouldShowLoadMore &&
                            (_hasMoreResults[currentBookTitle] ?? true)) ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Card(
                              color: Theme.of(context).colorScheme.surface,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        isLoading
                                            ? const SizedBox(
                                                width: 24,
                                                height: 24,
                                                child: CircularProgressIndicator(
                                                    strokeWidth: 2),
                                              )
                                            : Tooltip(
                                                message: 'تحميل المزيد',
                                                child: IconButton(
                                                  icon: const Icon(Icons.sync),
                                                  onPressed: () =>
                                                      loadMoreResults(currentBookTitle!),
                                                ),
                                              ),
                                        Text(
                                          '($totalResultsCount)',
                                          style:
                                              Theme.of(context).textTheme.titleSmall,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      'المزيد من النتائج',
                                      style: Theme.of(context).textTheme.titleSmall,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ],
                  ],
                );
              } else if (isExpanded) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (isLastResultOfBook &&
                        shouldShowLoadMore &&
                        (_hasMoreResults[currentBookTitle] ?? true)) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  isLoading
                                      ? const SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        )
                                      : Tooltip(
                                          message: 'تحميل المزيد',
                                          child: GestureDetector(
                                            onTap: () =>
                                                loadMoreResults(currentBookTitle!),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Icon(Icons.sync,
                                                      color: Theme.of(context)
                                                          .colorScheme
                                                          .secondary),
                                                ),
                                                Text(
                                                  'المزيد من النتائج',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleSmall
                                                      ?.copyWith(
                                                          color: Theme.of(context)
                                                              .colorScheme
                                                              .secondary),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ],
                );
              } else {
                return const SizedBox.shrink();
              }
            },
          ),
        ),
      ],
    );
  }

  List<Widget> _buildResultList(SearchModel result) {
    return [
      ListTile(
        title: GestureDetector(
          onTap: () {
            widget.onResultTap?.call(result);
          },
          child: Row(
            children: [
              Text(
                '${result.pageIndex}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Expanded(
                child: Html(
                  data: result.spanna ?? '',
                  style: {
                    'html': Style(
                      fontSize: FontSize.medium,
                      lineHeight: LineHeight(1.2),
                      textAlign: TextAlign.right,
                    ),
                    'mark': Style(
                      backgroundColor: Colors.yellow,
                    ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 0),
        child: Divider(
          thickness: 0.3,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    ];
  }
}
