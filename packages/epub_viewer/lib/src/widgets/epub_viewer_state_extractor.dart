import 'dart:ui';

import 'package:epub_parser/epub_parser.dart';
import '../models/search_model.dart';
import '../models/style_model.dart';
import '../cubit/epub_viewer_cubit.dart';

/// Extracts state data from EpubViewerState, with fallback to cubit cached values
class EpubViewerStateExtractor {
  static EpubViewerStateData extract(EpubViewerState state, EpubViewerCubit? cubit, {bool isDarkMode = false}) {
    final content = state.maybeWhen(
      loaded: (content, _, __) => content,
      contentHighlighted: (content, _, __) => content,
      orElse: () => <String>[],
    );

    final bookTitle = state.maybeWhen(
      loaded: (_, title, __) => title,
      orElse: () => '',
    );

    final tocList = state.maybeWhen(
      loaded: (_, __, tocList) => tocList,
      orElse: () => <EpubChapter>[],
    );

    final isBookmarked = state.maybeWhen(
      bookmarkPresent: () => true,
      orElse: () => false,
    );

    // Extract search results - use from state if available, otherwise use cubit's cached results
    List<SearchModel> searchResults = [];
    state.maybeWhen(
      searchResultsFound: (results) {
        searchResults = results;
      },
      orElse: () {
        // Fallback to cubit's search results if state doesn't have them
        searchResults = cubit?.currentSearchResults ?? <SearchModel>[];
      },
    );

    // Extract current page - use from state if available, otherwise use cubit's current page
    double currentPage = 0.0;
    state.maybeWhen(
      pageChanged: (pageNumber, _) {
        currentPage = pageNumber?.toDouble() ?? 0.0;
      },
      orElse: () {
        // Fallback to cubit's current page if state doesn't have it
        currentPage = cubit?.currentPage.toDouble() ?? 0.0;
      },
    );

    // Extract style - use from state if available, otherwise use cached from cubit or defaults
    FontSizeCustom? tempFontSize;
    LineHeightCustom? tempLineHeight;
    FontFamily? tempFontFamily;
    Color? tempBackgroundColor;
    bool? tempUseCustomBackgroundColor;
    bool? tempUseUniformTextColor;
    Color? tempUniformTextColor;
    bool? tempHideArabicDiacritics;
    
    state.maybeWhen(
      styleChanged:
          (fs, lh, ff, bg, useCustomBg, uniformEnabled, uniformColor, hideErab) {
        tempFontSize = fs;
        tempLineHeight = lh;
        tempFontFamily = ff;
        tempBackgroundColor = bg;
        tempUseCustomBackgroundColor = useCustomBg;
        tempUseUniformTextColor = uniformEnabled;
        tempUniformTextColor = uniformColor;
        tempHideArabicDiacritics = hideErab;
      },
      orElse: () {},
    );

    const darkBackgroundColor = Color(0xFF1B1B1B);
    const lightBackgroundColor = Color(0xFFFFFFFF);
    final bool useCustomBg =
        tempUseCustomBackgroundColor ?? cubit?.useCustomBackgroundColor ?? false;

    final Color backgroundColor;
    if (!useCustomBg) {
      backgroundColor = isDarkMode ? darkBackgroundColor : lightBackgroundColor;
    } else {
      final Color? candidateColor =
          tempBackgroundColor ?? cubit?.cachedBackgroundColor;
      if (isDarkMode) {
        if (candidateColor != null &&
            candidateColor.value == darkBackgroundColor.value) {
          backgroundColor = candidateColor;
        } else {
          backgroundColor = candidateColor ?? darkBackgroundColor;
        }
      } else {
        backgroundColor = candidateColor ?? lightBackgroundColor;
      }
    }

    return EpubViewerStateData(
      content: content,
      bookTitle: bookTitle,
      tocList: tocList,
      isBookmarked: isBookmarked,
      searchResults: searchResults,
      currentPage: currentPage,
      fontSize: tempFontSize ?? cubit?.cachedFontSize ?? FontSizeCustom.medium,
      lineHeight: tempLineHeight ?? cubit?.cachedLineHeight ?? LineHeightCustom.medium,
      fontFamily: tempFontFamily ?? cubit?.cachedFontFamily ?? FontFamily.font1,
      backgroundColor: backgroundColor,
      useCustomBackgroundColor: useCustomBg,
      useUniformTextColor: tempUseUniformTextColor ?? cubit?.useUniformTextColor ?? false,
      uniformTextColor: tempUniformTextColor ?? cubit?.cachedUniformTextColor ?? const Color(0xFF000000),
      hideArabicDiacritics: tempHideArabicDiacritics ?? cubit?.hideArabicDiacritics ?? false,
    );
  }
}

class EpubViewerStateData {
  final List<String> content;
  final String bookTitle;
  final List<EpubChapter>? tocList;
  final bool isBookmarked;
  final List<SearchModel> searchResults;
  final double currentPage;
  final FontSizeCustom fontSize;
  final LineHeightCustom lineHeight;
  final FontFamily fontFamily;
  final Color backgroundColor;
  final bool useCustomBackgroundColor;
  final bool useUniformTextColor;
  final Color uniformTextColor;
  final bool hideArabicDiacritics;

  EpubViewerStateData({
    required this.content,
    required this.bookTitle,
    this.tocList,
    required this.isBookmarked,
    required this.searchResults,
    required this.currentPage,
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.backgroundColor,
    required this.useCustomBackgroundColor,
    required this.useUniformTextColor,
    required this.uniformTextColor,
    required this.hideArabicDiacritics,
  });
}

