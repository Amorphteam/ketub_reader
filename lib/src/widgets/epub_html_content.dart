import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

import '../models/style_model.dart';
import 'epub_html_styles.dart';

class EpubHtmlContent extends StatelessWidget {
  final String content;
  final FontSizeCustom fontSize;
  final LineHeightCustom lineHeight;
  final FontFamily fontFamily;
  final bool isDarkMode;
  final GlobalKey? anchorKey;
  final Color backgroundColor;
  final Color? uniformTextColor;
  final void Function(BuildContext context, String anchorId)? onAnchorIdTap;

  const EpubHtmlContent({
    super.key,
    required this.content,
    required this.fontSize,
    required this.lineHeight,
    required this.fontFamily,
    required this.isDarkMode,
    this.anchorKey,
    required this.backgroundColor,
    this.uniformTextColor,
    this.onAnchorIdTap,
  });

  @override
  Widget build(BuildContext context) {
    return Html(
      anchorKey: anchorKey,
      onAnchorTap: (url, attributes, element) =>
          _handleAnchorTap(context, url, attributes, element),
      onLinkTap: (url, attributes, element) =>
          _handleLinkTap(context, url, attributes, element),
      data: content,
      style: EpubHtmlStyles.getStyles(
        fontSize: fontSize,
        lineHeight: lineHeight,
        fontFamily: fontFamily,
        isDarkMode: isDarkMode,
        backgroundColor: backgroundColor,
        uniformTextColor: uniformTextColor,
      ),
    );
  }

  /// Handles taps on in-page anchors (e.g. `<a href="#section1">`).
  ///
  /// This will attempt to scroll the tapped anchor into view within the
  /// current HTML widget using the provided [anchorKey].
  void _handleAnchorTap(
    BuildContext buildContext,
    String? url,
    Map<String, String> attributes,
    dom.Element? element,
  ) {
    if (url == null) return;

    // flutter_html sends the raw href; for in-page anchors this is usually
    // something like "#id" or "chapter.xhtml#id".
    final String anchorId = () {
      final hashIndex = url.indexOf('#');
      if (hashIndex == -1) {
        return url;
      }
      return url.substring(hashIndex + 1);
    }();

    if (anchorId.isEmpty) return;

    final fullId = '#$anchorId';

    // If the hosting app provided a handler, let it decide (e.g. bottom sheet + DB lookup).
    if (onAnchorIdTap != null) {
      onAnchorIdTap!(buildContext, fullId);
    } else {
      // Default behavior: show a simple SnackBar for #anchor links.
      final messenger = ScaffoldMessenger.maybeOf(buildContext);
      if (messenger != null) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(fullId),
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    try {
      final targetKey = AnchorKey.forId(anchorKey!, anchorId);
      final targetContext = targetKey?.currentContext;
      if (targetContext != null) {
        Scrollable.ensureVisible(
          targetContext,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    } catch (_) {
      // Fail silently – anchor navigation is a best-effort enhancement.
    }
  }

  /// Handles taps on regular links (non-`#` anchors).
  ///
  /// This is intentionally a no-op by default to keep the widget generic and
  /// reusable across apps. Consumers that need custom behavior (e.g. opening
  /// a browser or handling deep links) should wrap this widget and provide
  /// their own link-handling logic at a higher level.
  void _handleLinkTap(
    BuildContext buildContext,
    String? url,
    Map<String, String> attributes,
    dom.Element? element,
  ) {
    // Intentionally left empty. You can:
    // - Add logging here, or
    // - Fork/wrap this widget and implement app-specific link behavior.
  }
}

