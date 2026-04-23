import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

import 'cubit/epub_viewer_cubit.dart';
import 'helper/style_helper.dart';
import 'models/epub_viewer_entry_data.dart';
import 'models/search_model.dart';
import 'widgets/epub_content_list.dart';
import 'widgets/epub_page_slider.dart';
import 'widgets/epub_viewer_app_bar.dart';
import 'widgets/epub_viewer_state_extractor.dart';
import 'widgets/page_jump_dialog.dart';
import 'widgets/search_navigation_buttons.dart';
import 'widgets/style_sheet.dart';
import 'widgets/toc_tree_list_widget.dart';

export 'widgets/epub_content_list.dart' show CustomStyleBuilder;

void _epubNavDebugLog(String message) {
  if (kDebugMode) {
    debugPrint('[epub_nav] $message');
  }
}

class EpubViewerScreenV2 extends StatefulWidget {
  const EpubViewerScreenV2({
    super.key,
    required this.entryData,
    this.enableContentCache = true,
    this.showBottomBar = true,
    this.showAppBarSearchButton = true,
    this.showAppBarTocButton = true,
    this.onBookmarksChanged,
    this.onAnchorIdTap,
    this.onExtraActionPressed,
    this.isExtraActionVisible,
    this.extraActionIcon,
    this.customStyle,
    this.customStyleBuilder,
  });

  final EpubViewerEntryData entryData;
  final bool enableContentCache;
  /// When true, shows the bottom bar (page slider). When false, hides it.
  /// Defaults to true.
  final bool showBottomBar;
  /// When false, hides the search icon in the app bar (users cannot open in-reader search from there).
  final bool showAppBarSearchButton;
  /// When false, hides the table-of-contents icon in the app bar.
  final bool showAppBarTocButton;
  final Future<void> Function()? onBookmarksChanged;
  final void Function(BuildContext context, String anchorId)? onAnchorIdTap;
  final void Function(
    BuildContext context, {
    required int pageNumber,
    required String? sectionName,
    required String? bookName,
    required String? bookPath,
  })? onExtraActionPressed;
  final bool Function({
    required int pageNumber,
    required String? sectionName,
    required String? bookName,
    required String? bookPath,
  })? isExtraActionVisible;
  /// Custom icon for the extra action button (e.g. translate, audio).
  /// When null, defaults to translate icon.
  final IconData? extraActionIcon;
  final Map<String, Style>? customStyle;
  final CustomStyleBuilder? customStyleBuilder;

  @override
  _EpubViewerScreenV2State createState() => _EpubViewerScreenV2State();
}

class _EpubViewerScreenV2State extends State<EpubViewerScreenV2> {
  // Controllers
  late final ItemScrollController itemScrollController;
  late final ScrollOffsetController scrollOffsetController;
  late final ItemPositionsListener itemPositionsListener;
  late final ScrollOffsetListener scrollOffsetListener;
  late final _NavigationCoordinator _navigationCoordinator;
  final focusNode = FocusNode();
  final textEditingController = TextEditingController();
  final Map<int, String> _processedContentCache = {};
  List<String>? _lastContentListRef;
  late final VoidCallback _itemPositionsListenerCallback;
  double? _sliderDragValue;
  bool _pendingSliderCommit = false;
  bool _lastHideDiacritics = false;

  bool _hasLoadedEpub = false;
  bool _hasHandledInitialPageJump = false;
  /// Full-screen busy layer while the first in-reader search/highlight runs (e.g. from global search).
  bool _openingExternalSearch = false;
  EpubViewerCubit? _cubit; // Cache cubit reference for safe disposal
  Timer? _scrollDebounceTimer; // Debounce scroll listener to reduce emissions
  bool _isPageChangeFromScroll = false; // Track if page change came from scroll

  @override
  void initState() {
    super.initState();
    _initializeControllers();
    _navigationCoordinator = _NavigationCoordinator();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Cache cubit reference for safe disposal
    _cubit ??= context.read<EpubViewerCubit>();
    // Load EPUB based on source (only once)
    if (!_hasLoadedEpub) {
      _hasLoadedEpub = true;
      _loadEpubFromSource();
      _setupScrollListener();
    }
  }

  void _setupScrollListener() {
    // Listen to scroll position changes to update current page
    // Debounced to reduce unnecessary state emissions and rebuilds
    _itemPositionsListenerCallback = () {
      final positions = itemPositionsListener.itemPositions.value;
      if (positions.isEmpty ||
          _navigationCoordinator.isJumpInProgress ||
          _pendingSliderCommit) {
        return;
      }

      Iterable<ItemPosition> visiblePositions =
          positions.where((position) => position.itemLeadingEdge < 1);
      if (visiblePositions.isEmpty) {
        visiblePositions = positions;
      }

      final currentPageIndex = visiblePositions.reduce(
        (max, position) => position.index > max.index ? position : max,
      ).index;

      // Debounce scroll updates to reduce state emissions and rebuilds
      _scrollDebounceTimer?.cancel();
      _scrollDebounceTimer = Timer(const Duration(milliseconds: 150), () {
        if (!mounted) return;
        
        final cubit = context.read<EpubViewerCubit>();
        if (cubit.currentPage != currentPageIndex) {
          // Mark that this page change is from scroll (not programmatic)
          _isPageChangeFromScroll = true;
          cubit.updateCurrentPageFromScroll(currentPageIndex);
          // Reset flag after a short delay to allow state emission to process
          Future.delayed(const Duration(milliseconds: 50), () {
            _isPageChangeFromScroll = false;
          });
        }
      });
    };
    itemPositionsListener.itemPositions.addListener(_itemPositionsListenerCallback);
  }


  void _initializeControllers() {
    itemScrollController = ItemScrollController();
    scrollOffsetController = ScrollOffsetController();
    itemPositionsListener = ItemPositionsListener.create();
    scrollOffsetListener = ScrollOffsetListener.create();
  }

  void _loadEpubFromSource() {
    final cubit = context.read<EpubViewerCubit>();
    final data = widget.entryData;
    
    // Determine initial page based on source
    int? initialPage;
    String? tocChapterFileName;
    String? bookmarkFileName;
    
    if (data.bookmarkFileName != null && data.bookmarkFileName!.isNotEmpty) {
      // From bookmark (file name takes priority)
      bookmarkFileName = data.bookmarkFileName;
    } else if (data.bookmarkPageIndex != null &&
        data.bookmarkPageIndex!.isNotEmpty) {
      // Fall back to bookmark page index when file name absent
      initialPage = int.tryParse(data.bookmarkPageIndex!) ?? 0;
    } else if (data.historyPageIndex != null &&
        data.historyPageIndex!.isNotEmpty) {
      // From history
      initialPage = int.tryParse(data.historyPageIndex!) ?? 0;
    } else if (data.searchPageIndex != null) {
      // From search (pageIndex is 1-based, convert to 0-based)
      initialPage = data.searchPageIndex! - 1;
    } else if (data.tocChapterFileName != null &&
        data.tocChapterFileName!.isNotEmpty) {
      // From TOC - use chapter file name for navigation
      tocChapterFileName = data.tocChapterFileName;
    } else if (data.deepLinkPageIndex != null) {
      // From deep link
      initialPage = data.deepLinkPageIndex;
      // file name navigation handled later if provided
    }
    
    cubit.initializeEpubLoading(
      bookPath: data.primaryBookPath,
      bookmarkPath: data.bookmarkBookPath,
      bookmarkFileName: bookmarkFileName,
      historyPath: data.historyBookPath,
      searchPath: data.searchBookPath,
      tocPath: data.tocBookPath,
      deepLinkPath: data.deepLinkBookPath,
      tocChapterFileName: tocChapterFileName,
      deepLinkFileName: data.deepLinkChapterFileName,
      initialPage: initialPage,
    );
  }

  @override
  void dispose() {
    // Cancel scroll debounce timer to prevent leaks
    _scrollDebounceTimer?.cancel();
    _scrollDebounceTimer = null;
    
    // History saving is handled by cubit.close() which is called automatically
    // But we also save here to ensure it happens before widget disposal
    // Use cached cubit reference instead of context.read() which is unsafe in dispose()
    if (_cubit != null) {
      _cubit!.saveCurrentHistory();
      _cubit!.saveCurrentPageProgress();
      _cubit!.cancelIOSSliderDebounce();
    }
    _processedContentCache.clear();
    _lastContentListRef = null;
    itemPositionsListener.itemPositions.removeListener(_itemPositionsListenerCallback);
    _navigationCoordinator.reset();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: SystemUiOverlay.values,
    );
    focusNode.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return BlocConsumer<EpubViewerCubit, EpubViewerState>(
      listener: _handleStateChanges,
      builder: (context, state) {
        final cubit = context.read<EpubViewerCubit>();
        final stateData = EpubViewerStateExtractor.extract(state, cubit, isDarkMode: isDarkMode);
        _updateSystemUI(cubit.isSliderVisible);

        return Scaffold(
          backgroundColor: stateData.backgroundColor,
          appBar: _buildAppBar(context, cubit, stateData, isDarkMode),
          body: SafeArea(
            child: Stack(
              children: [
                _buildContentArea(
                  context,
                  state,
                  stateData,
                  isDarkMode,
                  showBottomBar: widget.showBottomBar && cubit.isSliderVisible,
                ),
                _buildSearchNavigation(stateData),
                if (_openingExternalSearch) _buildOpeningBusyOverlay(context),
              ],
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget? _buildAppBar(
    BuildContext context,
    EpubViewerCubit cubit,
    EpubViewerStateData stateData,
    bool isDarkMode,
  ) {
    if (!cubit.isSliderVisible) {
      return null;
    }

    final bool isExtraVisible = _isExtraActionVisible(stateData);

    return EpubViewerAppBar(
      isSearchOpen: cubit.isSearchOpen,
      isBookmarked: stateData.isBookmarked,
      isAboutUsBook: cubit.isAboutUsBook,
      focusNode: focusNode,
      textEditingController: textEditingController,
      onBackPressed: () => _handleBackPressed(cubit),
      onSearchToggle: () {
        // Toggle search - this will emit a state to trigger rebuild
        final wasOpen = cubit.isSearchOpen;
        cubit.toggleSearch(!wasOpen);
        // Focus the search field when opened
        if (!wasOpen) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && focusNode.canRequestFocus) {
              focusNode.requestFocus();
            }
          });
        }
      },
      onSearchSubmitted: () {
        if (textEditingController.text.isNotEmpty) {
          _navigationCoordinator.requestJump();
          cubit.searchUsingHtmlList(textEditingController.text);
        }
      },
      onStylePressed: () => _showStyleBottomSheet(context, cubit, stateData),
      onBookmarkPressed: () => _handleBookmarkToggle(context, cubit),
      onTocPressed: () => _showTocBottomSheet(context, cubit, isDarkMode),
      showExtraActionButton: widget.onExtraActionPressed != null && isExtraVisible,
      onExtraActionPressed: widget.onExtraActionPressed != null && isExtraVisible
          ? () => _handleExtraActionPressed(context, stateData)
          : null,
      extraActionIcon: widget.extraActionIcon,
      showSearchButton: widget.showAppBarSearchButton,
      showTocButton: widget.showAppBarTocButton,
    );
  }

  bool _isExtraActionVisible(EpubViewerStateData stateData) {
    if (widget.onExtraActionPressed == null) {
      return false;
    }

    final resolver = widget.isExtraActionVisible;
    if (resolver == null) {
      return true;
    }

    final cubit = context.read<EpubViewerCubit>();
    final data = widget.entryData;
    final String? bookPath = data.primaryBookPath ??
        data.bookmarkBookPath ??
        data.historyBookPath ??
        data.searchBookPath ??
        data.tocBookPath ??
        data.deepLinkBookPath;
    final String? bookName = stateData.bookTitle.isNotEmpty
        ? stateData.bookTitle
        : cubit.cachedBookTitle;
    final String? sectionName = cubit.currentSectionFileName;

    return resolver(
      pageNumber: cubit.currentPage,
      sectionName: sectionName,
      bookName: bookName,
      bookPath: bookPath,
    );
  }

  void _handleStateChanges(BuildContext context, EpubViewerState state) {
    final cubit = context.read<EpubViewerCubit>();
    
    state.maybeWhen(
      loaded: (content, title, tocList) {
        if (!_hasHandledInitialPageJump) {
          _hasHandledInitialPageJump = true;

          // Set flag for initial navigation (handled by cubit.handlePostLoadNavigation)
          // This ensures that when pageChanged is emitted from post-load navigation,
          // the screen will actually jump to the page
          _navigationCoordinator.requestJump();

          // Navigation is now handled by cubit.handlePostLoadNavigation()
          // which is called automatically after loading
          // But we still need to handle search and deep links here

          // Handle search model if provided (external search).
          // Post-load navigation runs before `loaded` in the cubit; one frame is enough
          // for the scrollable list to attach before searching/highlighting.
          final initialSearchQuery = widget.entryData.searchQuery;
          if (initialSearchQuery != null && initialSearchQuery.isNotEmpty) {
            setState(() => _openingExternalSearch = true);
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _navigationCoordinator.requestJump();
              cubit.searchUsingHtmlList(initialSearchQuery);
            });
          }

          // Handle deep link file name jump after first layout (if still needed).
          final deepLinkFileName = widget.entryData.deepLinkChapterFileName;
          if (deepLinkFileName != null && deepLinkFileName.isNotEmpty) {
            final String fileName = deepLinkFileName;
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              _navigationCoordinator.requestJump();
              cubit.jumpToPage(
                chapterFileName: fileName,
                tryChapterTextPrefixFallback: true,
              );
            });
          }
        }

        // Load user preferences
        cubit.loadUserPreferences();
      },
      searchResultsFound: (searchResults) {
        if (searchResults.isEmpty) {
          if (_openingExternalSearch && mounted) {
            setState(() => _openingExternalSearch = false);
          }
          // Get the search term from the text controller
          final searchTerm = textEditingController.text.isNotEmpty
              ? textEditingController.text
              : (widget.entryData.searchQuery ?? '');
          final displayQuery = searchTerm.isEmpty ? '...' : searchTerm;
          
          // Show snackbar to inform user that no results were found
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'لم يتم العثور على "$displayQuery"',
                textAlign: TextAlign.center,
              ),
              duration: const Duration(seconds: 3),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
        // Search results are handled automatically by cubit (auto-highlights first result)
        // No additional action needed here when results are found
      },
      contentHighlighted: (content, highlightedIndex, pageHighlights) {
        if (_openingExternalSearch && mounted) {
          setState(() => _openingExternalSearch = false);
        }
        final cubit0 = context.read<EpubViewerCubit>();
        final idsOnPage = pageHighlights[highlightedIndex];
        _epubNavDebugLog(
          'contentHighlighted: spineIndex=$highlightedIndex '
          'cubit.currentPage=${cubit0.currentPage} '
          'currentHighlightId=${cubit0.getCurrentHighlightId()} '
          'anchorIdsOnThisPage=${idsOnPage?.length ?? 0} ids=$idsOnPage',
        );
        // Legacy Masaha: always new GlobalKey + jumpTo for highlight flows (same page ok).
        _navigationCoordinator.requestJump();
        _scrollToPage(highlightedIndex, legacyMasahaHighlightJump: true);

        WidgetsBinding.instance.addPostFrameCallback((_) {
          final cubit = context.read<EpubViewerCubit>();
          final highlightId = cubit.getCurrentHighlightId();
          if (highlightId != null) {
            _epubNavDebugLog(
              'contentHighlighted postFrame: will _scrollToHighlight id=$highlightId',
            );
            _scrollToHighlight(highlightId);
          } else {
            _epubNavDebugLog(
              'contentHighlighted postFrame: getCurrentHighlightId() is null — '
              'no in-page ensureVisible; you likely only see spine page top.',
            );
          }
        });
      },
      pageChanged: (pageNumber, _) {
        if (_pendingSliderCommit) {
          _pendingSliderCommit = false;
          if (_sliderDragValue != null) {
            setState(() {
              _sliderDragValue = null;
            });
          }
        }
        // Scroll to the page when pageChanged is emitted from cubit
        // BUT skip if the change came from scroll (to prevent circular scroll loop)
        if (pageNumber != null && !_isPageChangeFromScroll) {
          final cubit = context.read<EpubViewerCubit>();
          final highlightId = cubit.getCurrentHighlightId();
          _epubNavDebugLog(
            'pageChanged (programmatic): spineIndex=$pageNumber '
            'highlightId=$highlightId searchResults=${cubit.currentSearchResults.length}',
          );
          _navigationCoordinator.requestJump();
          _scrollToPage(
            pageNumber,
            legacyMasahaHighlightJump: highlightId != null,
          );

          if (highlightId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _epubNavDebugLog(
                  'pageChanged postFrame: _scrollToHighlight id=$highlightId',
                );
                _scrollToHighlight(highlightId);
              }
            });
          } else {
            _epubNavDebugLog(
              'pageChanged: no highlightId — spine jump only, no ensureVisible to mark.',
            );
          }
        } else if (pageNumber != null && _isPageChangeFromScroll) {
          final cubit = context.read<EpubViewerCubit>();
          final highlightId = cubit.getCurrentHighlightId();
          _navigationCoordinator.updateCurrentPageKey(pageNumber);

          if (highlightId != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                _scrollToHighlight(highlightId);
              }
            });
          }
        }
      },
      error: (error) {
        if (_openingExternalSearch && mounted) {
          setState(() => _openingExternalSearch = false);
        }
        if (error.toLowerCase().contains('translation') ||
            error.contains('No translation content found')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text(
                  'لا توجد ترجمات مفعلة. يرجى تفعيل ترجمة واحدة على الأقل من الإعدادات.'),
              duration: const Duration(seconds: 6),
              behavior: SnackBarBehavior.floating,
              action: SnackBarAction(
                label: 'الإعدادات',
                onPressed: () => Navigator.pushNamed(context, '/settingScreen'),
              ),
            ),
          );
        }
      },
      orElse: () {},
    );
  }

  void _scrollToPage(int pageNumber, {bool legacyMasahaHighlightJump = false}) {
    // Same spine page + highlight: rotating the Html key is enough; jumpTo() again
    // thrashes ScrollablePositionedList, fires item listeners, and skips frames.
    final bool highlightOnlySamePage = legacyMasahaHighlightJump &&
        pageNumber == _navigationCoordinator.lastPageForKey;

    final bool pageChanged;
    if (legacyMasahaHighlightJump) {
      _navigationCoordinator.legacyPreparePageJump(pageNumber);
      pageChanged = true;
    } else {
      pageChanged = _navigationCoordinator.updateCurrentPageKey(pageNumber);
    }

    _epubNavDebugLog(
      '_scrollToPage: spineIndex=$pageNumber legacyHighlight=$legacyMasahaHighlightJump '
      'highlightOnlySamePage=$highlightOnlySamePage pageKeyChanged=$pageChanged '
      'listAttached=${itemScrollController.isAttached}',
    );

    if (highlightOnlySamePage) {
      _navigationCoordinator.clearJumpRequest();
      _epubNavDebugLog(
        '_scrollToPage: same spine page + highlight — skipped itemScrollController.jumpTo '
        '(Html key refresh only).',
      );
      if (mounted) setState(() {});
      return;
    }

    if (!itemScrollController.isAttached) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && itemScrollController.isAttached) {
          _attemptJumpToPage(pageNumber, pageChanged);
        } else {
          _epubNavDebugLog(
            '_scrollToPage: deferred jump aborted (not mounted or list not attached).',
          );
        }
      });
      return;
    }

    _attemptJumpToPage(pageNumber, pageChanged);
  }

  void _attemptJumpToPage(int pageNumber, bool pageChanged) {
    if (!pageChanged) {
      _navigationCoordinator.clearJumpRequest();
      return;
    }

    if (!_navigationCoordinator.consumeJumpRequest()) {
      return;
    }

    try {
      _epubNavDebugLog(
        '_attemptJumpToPage: ScrollablePositionedList.jumpTo(index=$pageNumber) '
        '(outer spine list — shows start of that HTML chunk).',
      );
      itemScrollController.jumpTo(index: pageNumber);
    } catch (e) {
      debugPrint('Error scrolling to page: $e');
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _navigationCoordinator.markJumpComplete();
      });
    }
  }

  void _updateSystemUI(bool isSliderVisible) {
    if (!isSliderVisible) {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    } else {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: SystemUiOverlay.values,
      );
    }
  }

  Widget _buildOpeningBusyOverlay(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // Fully opaque so spine content never bleeds through (semi-transparent felt "broken").
    return Positioned.fill(
      child: AbsorbPointer(
        child: Material(
          color: scheme.surface,
          elevation: 6,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  RepaintBoundary(
                    child: CircularProgressIndicator(
                      color: scheme.primary,
                      strokeWidth: 3,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'جارٍ البحث في الصفحات وترتيب النتائج',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'يرجى الانتظار.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleBackPressed(EpubViewerCubit cubit) {
    if (cubit.isSearchOpen) {
      cubit.toggleSearch(false);
      textEditingController.clear();
      focusNode.unfocus();
      // Content restoration is handled by cubit.toggleSearch(false)
    } else {
      Navigator.of(context).pop();
    }
  }

  Widget _buildContentArea(
    BuildContext context,
    EpubViewerState state,
    EpubViewerStateData stateData,
    bool isDarkMode, {
    required bool showBottomBar,
  }) {
    return Align(
      alignment: Alignment.topCenter,
      child: Container(
        color: stateData.backgroundColor,
        child: state.maybeWhen(
          loading: () => Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(color: Colors.red),
                  const SizedBox(height: 20),
                  Text(
                    'جارٍ فتح الكتاب…',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'قد يستغرق ذلك لحظات للكتب الكبيرة.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ),
          initial: () => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(
                  'جارٍ التحميل…',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ],
            ),
          ),
          orElse: () => _buildContent(
            context,
            stateData,
            isDarkMode,
            showBottomBar: showBottomBar,
          ),
        ),
      ),
    );
  }

  Widget _buildContent(
    BuildContext context,
    EpubViewerStateData stateData,
    bool isDarkMode, {
    required bool showBottomBar,
  }) {
    final cubit = context.read<EpubViewerCubit>();
    
    // Use cached content from cubit if current state doesn't have content
    final content = stateData.content.isNotEmpty
        ? stateData.content
        : cubit.cachedContent;
    final bookTitle = stateData.bookTitle.isNotEmpty
        ? stateData.bookTitle
        : cubit.cachedBookTitle;
    // Style is already extracted with fallback to cached values in state extractor
    final fontSize = stateData.fontSize;
    final lineHeight = stateData.lineHeight;
    final fontFamily = stateData.fontFamily;
    final resolvedUniformTextColor = stateData.useUniformTextColor
        ? StyleHelper.themeUniformTextColor(
            isDarkMode ? Brightness.dark : Brightness.light,
          )
        : stateData.uniformTextColor;
    final styleSignature =
        '${fontSize.index}-${lineHeight.index}-${fontFamily.index}-${stateData.backgroundColor.value}-${stateData.useCustomBackgroundColor}-${stateData.useUniformTextColor}-${resolvedUniformTextColor.value}-${stateData.hideArabicDiacritics}';
    final sliderValue = _sliderDragValue ?? stateData.currentPage;

    if (content.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (widget.enableContentCache) {
      _syncContentCacheReference(content);
    } else {
      _processedContentCache.clear();
      _lastContentListRef = null;
    }
    if (_lastHideDiacritics != stateData.hideArabicDiacritics) {
      _processedContentCache.clear();
      _lastHideDiacritics = stateData.hideArabicDiacritics;
    }

    return Column(
      children: [
        Expanded(
          child: EpubContentList(
            content: content,
            itemScrollController: itemScrollController,
            scrollOffsetController: scrollOffsetController,
            itemPositionsListener: itemPositionsListener,
            scrollOffsetListener: scrollOffsetListener,
            fontSize: fontSize,
            lineHeight: lineHeight,
            fontFamily: fontFamily,
            isDarkMode: isDarkMode,
            currentPage: cubit.currentPage,
            currentPageKey: _navigationCoordinator.currentPageKey,
            processedContentBuilder: widget.enableContentCache
                ? (index) => _getProcessedContent(index, content[index])
                : null,
            backgroundColor: stateData.backgroundColor,
            useUniformTextColor: stateData.useUniformTextColor,
            uniformTextColor: resolvedUniformTextColor,
            styleSignature: styleSignature,
            onAnchorIdTap: widget.onAnchorIdTap,
            customStyle: widget.customStyle,
            customStyleBuilder: widget.customStyleBuilder,
          ),
        ),
        if (showBottomBar)
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: EpubPageSlider(
              currentPage: sliderValue,
              maxPages: content.length.toDouble(),
              bookTitle: bookTitle,
              isAboutUsBook: cubit.isAboutUsBook,
              onChanged: _handleSliderChanged,
              onChangedEnd: defaultTargetPlatform == TargetPlatform.iOS
                  ? null
                  : _handleSliderChangeEnd,
              onPageJump: () {
                final cubit = context.read<EpubViewerCubit>();
                _handlePageJump(context, cubit, content.length);
              },
            ),
          ),
      ],
    );
  }

  void _handleSliderChanged(double newValue) {
    if (_sliderDragValue != newValue) {
      setState(() {
        _sliderDragValue = newValue;
      });
    }

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      final cubit = context.read<EpubViewerCubit>();
      cubit.handleIOSSliderChange(newValue, () {
        if (mounted) {
          final targetPage = newValue.toInt();
          if (cubit.currentPage == targetPage) {
            _pendingSliderCommit = false;
            if (_sliderDragValue != null) {
              setState(() {
                _sliderDragValue = null;
              });
            }
            return;
          }
          _pendingSliderCommit = true;
          _navigationCoordinator.requestJump();
          cubit.jumpToPage(newPage: targetPage);
        }
      });
    }
  }

  void _handleSliderChangeEnd(double newValue) {
    final cubit = context.read<EpubViewerCubit>();
    final targetPage = newValue.toInt();

    if (cubit.currentPage == targetPage) {
      _pendingSliderCommit = false;
      if (_sliderDragValue != null) {
        setState(() {
          _sliderDragValue = null;
        });
      }
      return;
    }

    _pendingSliderCommit = true;
    _navigationCoordinator.requestJump();
    cubit.jumpToPageFromSlider(newValue);
  }

  Widget _buildSearchNavigation(EpubViewerStateData stateData) {
    final cubit = context.read<EpubViewerCubit>();
    List<SearchModel> _resolveResults() => _effectiveSearchResults(cubit, stateData);
    
    return SearchNavigationButtons(
      searchResults: _resolveResults(),
      currentSearchIndex: cubit.currentSearchIndex,
      onPrevious: () {
        final results = _resolveResults();
        if (results.isNotEmpty) {
          _navigationCoordinator.requestJump();
          cubit.navigateToPreviousSearchResult(results);
        }
      },
      onNext: () {
        final results = _resolveResults();
        if (results.isNotEmpty) {
          _navigationCoordinator.requestJump();
          cubit.navigateToNextSearchResult(results);
        }
      },
      onShowResults: () {
        _showSearchResultsDialog(context, cubit, _resolveResults());
      },
    );
  }

  List<SearchModel> _effectiveSearchResults(
    EpubViewerCubit cubit,
    EpubViewerStateData stateData,
  ) {
    final cubitResults = cubit.currentSearchResults;
    if (cubitResults.isNotEmpty) {
      return cubitResults;
    }
    return stateData.searchResults;
  }

  void _handleExtraActionPressed(
    BuildContext context,
    EpubViewerStateData stateData,
  ) {
    final callback = widget.onExtraActionPressed;
    if (callback == null) return;

    final cubit = context.read<EpubViewerCubit>();
    final int pageNumber = cubit.currentPage;

    // Best-effort book name from state or cubit cache.
    final String? bookName = stateData.bookTitle.isNotEmpty
        ? stateData.bookTitle
        : cubit.cachedBookTitle;
    final String? sectionName = cubit.currentSectionFileName;

    // Book path from entry data (primary if available, otherwise fallbacks).
    final data = widget.entryData;
    final String? bookPath = data.primaryBookPath ??
        data.bookmarkBookPath ??
        data.historyBookPath ??
        data.searchBookPath ??
        data.tocBookPath ??
        data.deepLinkBookPath;

    callback(
      context,
      pageNumber: pageNumber,
      sectionName: sectionName,
      bookName: bookName,
      bookPath: bookPath,
    );
  }
  
  /// Same idea as legacy `_scrollToId`: one post-frame, one `ensureVisible`, no retries.
  /// Multiple matches in one paragraph may share one anchor — missing context is expected.
  void _scrollToHighlight(String highlightId) {
    final currentPageKey = _navigationCoordinator.currentPageKey;
    if (currentPageKey == null) {
      _epubNavDebugLog(
        '_scrollToHighlight($highlightId): currentPageKey is null — cannot resolve AnchorKey.',
      );
      return;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      try {
        final cubit = context.read<EpubViewerCubit>();
        // In-reader search (FAB / result list): jump immediately; no 300ms ease.
        final bool searchJump = cubit.currentSearchResults.isNotEmpty;
        final anchorKey = AnchorKey.forId(currentPageKey, highlightId);
        final anchorContext = anchorKey?.currentContext;
        if (anchorContext != null) {
          _epubNavDebugLog(
            '_scrollToHighlight($highlightId): AnchorKey HIT — calling '
            'Scrollable.ensureVisible (in-page scroll to block/anchor). '
            'instant=${searchJump ? 'yes' : 'no'}',
          );
          Scrollable.ensureVisible(
            anchorContext,
            duration:
                searchJump ? Duration.zero : const Duration(milliseconds: 300),
            curve: searchJump ? Curves.linear : Curves.easeInOut,
            alignment: 0.12,
          );
        } else {
          _epubNavDebugLog(
            '_scrollToHighlight($highlightId): AnchorKey MISS (no context) — '
            'flutter_html did not build a widget for this id (duplicate id inline, '
            'or id only on inner <mark>). In-page scroll skipped; page top only.',
          );
        }
      } catch (e) {
        debugPrint('Error scrolling to highlight: $e');
      }
    });
  }

  void _showSearchResultsDialog(
    BuildContext context,
    EpubViewerCubit cubit,
    List<SearchModel> searchResults,
  ) {
    if (searchResults.isEmpty) return;

    final isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: Icon(isIOS ? CupertinoIcons.xmark : Icons.close),
              onPressed: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0, left: 16, top: 8, bottom: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: Text(
                  'كل النتائج: ${searchResults.length}',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: searchResults.length,
            itemBuilder: (context, index) {
              final result = searchResults[index];
              return Column(
                children: [
                  ListTile(
                    dense: true,
                    title: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pop();
                        _navigationCoordinator.requestJump();
                        cubit.navigateToSearchResult(index);
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
                  if (index < searchResults.length - 1)
                    Divider(
                      height: 1,
                      thickness: 0.3,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _handlePageJump(
    BuildContext context,
    EpubViewerCubit cubit,
    int totalPages,
  ) async {
    if (totalPages <= 0) return;

    final targetPage = await PageJumpDialog.show(
      context: context,
      totalPages: totalPages,
    );

    if (targetPage != null) {
      _navigationCoordinator.requestJump();
      cubit.jumpToPage(newPage: targetPage);
    }
  }

  void _showStyleBottomSheet(BuildContext context, EpubViewerCubit cubit, EpubViewerStateData stateData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => DraggableScrollableSheet(
          initialChildSize: 0.5,
          minChildSize: 0.25,
          maxChildSize: 0.9,
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
              controller: scrollController,
              child: Column(
                children: [
                  StyleSheet(
                    epubViewerCubit: cubit,
                    lineSpace: stateData.lineHeight,
                    fontFamily: stateData.fontFamily,
                    fontSize: stateData.fontSize,
                    useCustomBackgroundColor: stateData.useCustomBackgroundColor,
                    useUniformTextColor: stateData.useUniformTextColor,
                    hideArabicDiacritics: stateData.hideArabicDiacritics,
                  ),
                ],
              ),
            ),
        ),
    );
  }

  Future<void> _handleBookmarkToggle(BuildContext context, EpubViewerCubit cubit) async {
    await cubit.toggleBookmark();
    await widget.onBookmarksChanged?.call();
  }

  void _showTocBottomSheet(BuildContext context, EpubViewerCubit cubit, bool isDarkMode) {
    final tocList = cubit.tocTreeList;
    if (tocList == null || tocList.isEmpty) return;

    // This variable holds the state of the AppBar visibility
    final ValueNotifier<bool> showAppBar = ValueNotifier(false);

    showModalBottomSheet(
      backgroundColor: isDarkMode ? Colors.black : Colors.white,
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) => NotificationListener<DraggableScrollableNotification>(
        onNotification: (notification) {
          // When the sheet is fully expanded, show the AppBar
          showAppBar.value = notification.extent == notification.maxExtent;
          return true; // Return true to cancel the notification bubbling.
        },
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: DraggableScrollableSheet(
            expand: false,
            initialChildSize: 0.5,
            minChildSize: 0.25,
            maxChildSize: 1.0,
            builder: (BuildContext context, ScrollController scrollController) => Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 26, right: 16, left: 16),
                  // Reserve space for the AppBar-like header
                  child: EpubChapterListWidget(
                    tocTreeList: tocList,
                    scrollController: scrollController,
                    epubViewerCubit: cubit,
                    onClose: () {
                      Future.delayed(const Duration(milliseconds: 300), () {
                        Navigator.pop(context);
                      });
                    },
                    onNavigate: () {
                      _navigationCoordinator.requestJump();
                    },
                  ),
                ),
                // Use ValueListenableBuilder to react to changes in showAppBar
                ValueListenableBuilder<bool>(
                  valueListenable: showAppBar,
                  builder: (context, value, child) {
                    if (value) {
                      return Positioned(
                        top: 20,
                        left: 0,
                        right: 0,
                        child: SafeArea(
                          child: Container(
                            height: 56,
                            // Standard AppBar height
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            alignment: Alignment.centerRight,
                            color: Colors.transparent,
                            // Adjust the color as needed
                            child: IconButton(
                              icon: Icon(defaultTargetPlatform == TargetPlatform.iOS
                                  ? Icons.chevron_left
                                  : Icons.arrow_back),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return const SizedBox.shrink();
                    } // If false, don't show anything
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _syncContentCacheReference(List<String> content) {
    final bool isNewList = !identical(_lastContentListRef, content);
    final bool lengthChanged =
        _lastContentListRef != null && _lastContentListRef!.length != content.length;
    if (isNewList || lengthChanged) {
      _processedContentCache.clear();
      _lastContentListRef = content;
    } else if (_processedContentCache.isNotEmpty) {
      _processedContentCache.removeWhere((key, _) => key >= content.length);
    }
  }

  String _getProcessedContent(int index, String rawContent) {
    final cachedContent = _processedContentCache[index];
    if (cachedContent != null) {
      return cachedContent;
    }

    final cubit = context.read<EpubViewerCubit>();
    final processedContent = cubit.processHtmlContent(
      rawContent,
      hideArabicDiacritics: _lastHideDiacritics,
    );
    _processedContentCache[index] = processedContent;
    return processedContent;
  }

}

class _NavigationCoordinator {
  GlobalKey? _currentPageKey;
  int _lastPageForKey = -1;
  bool _shouldJumpToPage = false;
  bool _jumpInProgress = false;

  GlobalKey? get currentPageKey => _currentPageKey;
  int get lastPageForKey => _lastPageForKey;
  bool get isJumpInProgress => _jumpInProgress;

  void requestJump() {
    _shouldJumpToPage = true;
  }

  bool consumeJumpRequest() {
    final shouldJump = _shouldJumpToPage;
    _shouldJumpToPage = false;
     if (shouldJump) {
       _jumpInProgress = true;
     }
    return shouldJump;
  }

  void clearJumpRequest() {
    _shouldJumpToPage = false;
    _jumpInProgress = false;
  }

  bool updateCurrentPageKey(int pageNumber) {
    final bool pageChanged = _lastPageForKey != pageNumber;
    // Only recreate GlobalKey when page actually changed
    // This prevents unnecessary widget recreation on every scroll event
    if (pageChanged) {
      _currentPageKey = GlobalKey();
      _lastPageForKey = pageNumber;
    }
    return pageChanged;
  }

  /// Legacy Masaha `_jumpTo`: new [GlobalKey] on every highlight-driven list jump,
  /// even when the spine index is unchanged (search arrows on same page).
  void legacyPreparePageJump(int pageNumber) {
    _currentPageKey = GlobalKey();
    _lastPageForKey = pageNumber;
  }

  void reset() {
    _currentPageKey = null;
    _lastPageForKey = -1;
    _shouldJumpToPage = false;
    _jumpInProgress = false;
  }

  void markJumpComplete() {
    _jumpInProgress = false;
  }
}
