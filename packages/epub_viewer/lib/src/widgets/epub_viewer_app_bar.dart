import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';

class EpubViewerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool isSearchOpen;
  final bool isBookmarked;
  final bool isAboutUsBook;
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  final VoidCallback? onBackPressed;
  final VoidCallback? onSearchToggle;
  final VoidCallback? onSearchSubmitted;
  final VoidCallback? onStylePressed;
  final VoidCallback? onBookmarkPressed;
  final VoidCallback? onTocPressed;
  final VoidCallback? onExtraActionPressed;
  final bool showExtraActionButton;
  final VoidCallback? onEditionSwitchPressed;
  final bool showEditionSwitchButton;
  /// Custom icon for the extra action button (e.g. translate, audio).
  /// When null, defaults to translate icon for backward compatibility.
  final IconData? extraActionIcon;
  /// Custom icon for the edition-switch button.
  /// When null, defaults to swap/link-style platform icons.
  final IconData? editionSwitchIcon;
  /// When false, the search action is not shown (in-reader search cannot be opened from the bar).
  final bool showSearchButton;
  /// When false, the table-of-contents action is not shown.
  final bool showTocButton;
  /// Status bar style (icon brightness). When null, falls back to the theme.
  final SystemUiOverlayStyle? systemOverlayStyle;

  const EpubViewerAppBar({
    super.key,
    required this.isSearchOpen,
    required this.isBookmarked,
    required this.isAboutUsBook,
    required this.focusNode,
    required this.textEditingController,
    this.onBackPressed,
    this.onSearchToggle,
    this.onSearchSubmitted,
    this.onStylePressed,
    this.onBookmarkPressed,
    this.onTocPressed,
    this.onExtraActionPressed,
    this.showExtraActionButton = false,
    this.onEditionSwitchPressed,
    this.showEditionSwitchButton = false,
    this.extraActionIcon,
    this.editionSwitchIcon,
    this.showSearchButton = true,
    this.showTocButton = true,
    this.systemOverlayStyle,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final bool isIOS = defaultTargetPlatform == TargetPlatform.iOS;

    return AppBar(
      backgroundColor: Colors.transparent,
      systemOverlayStyle: systemOverlayStyle,
      leading: IconButton(
        icon: isSearchOpen
            ? Icon(isIOS ? CupertinoIcons.xmark : Icons.close)
            : Icon(isIOS ? CupertinoIcons.chevron_back : Icons.arrow_back),
        onPressed: onBackPressed,
      ),
      title: isSearchOpen
          ? TextField(
              autofocus: true,
              focusNode: focusNode,
              controller: textEditingController,
              decoration: InputDecoration(
                hintText: 'أدخل كلمة لبدء البحث ...',
                border: InputBorder.none,
                suffixIcon: IconButton(
                  icon: SvgPicture.asset('assets/icon/search.svg'),
                  onPressed: onSearchSubmitted != null
                      ? () {
                          if (textEditingController.text.isNotEmpty) {
                            onSearchSubmitted!();
                          }
                        }
                      : null,
                ),
              ),
              onSubmitted: (_) => onSearchSubmitted?.call(),
            )
          : const SizedBox.shrink(),
      actions: isSearchOpen || isAboutUsBook
          ? null
          : [
              if (showSearchButton)
                IconButton(
                  icon: Icon(
                      isIOS ? CupertinoIcons.search : Icons.search_rounded),
                  onPressed: onSearchToggle,
                ),
              IconButton(
                icon: Icon(isIOS
                    ? CupertinoIcons.textformat
                    : Icons.format_color_text_rounded),
                onPressed: onStylePressed,
              ),
              IconButton(
                icon: isBookmarked
                    ? Icon(isIOS
                        ? CupertinoIcons.bookmark_fill
                        : Icons.bookmark)
                    : Icon(isIOS
                        ? CupertinoIcons.bookmark
                        : Icons.bookmark_border),
                onPressed: onBookmarkPressed,
              ),
              if (showExtraActionButton)
                IconButton(
                  icon: Icon(
                    extraActionIcon ??
                        (isIOS
                            ? CupertinoIcons.globe
                            : Icons.translate_rounded),
                  ),
                  onPressed: onExtraActionPressed,
                ),
              if (showEditionSwitchButton)
                IconButton(
                  icon: Icon(
                    editionSwitchIcon ??
                        (isIOS
                            ? CupertinoIcons.arrow_2_squarepath
                            : Icons.swap_horiz_rounded),
                  ),
                  onPressed: onEditionSwitchPressed,
                ),
              if (showTocButton)
                IconButton(
                  icon: Icon(
                      isIOS ? CupertinoIcons.list_bullet : Icons.toc_rounded),
                  onPressed: onTocPressed,
                ),
            ],
    );
  }
}

