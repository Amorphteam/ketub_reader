import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Search AppBar widget with the same UI as CustomAppBar
/// This is a self-contained version to break dependencies
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final IconData? leftIcon;
  final Widget? leftWidget;
  final IconData? rightIcon;
  final Widget? rightWidget;
  final VoidCallback? onLeftTap;
  final VoidCallback? onRightTap; // New callback for right icon
  final List<String> recentSearches;
  final ValueChanged<String>? onRecentSelected;
  final ValueChanged<String>? onRecentDelete;
  final Function(String)? onSubmitted;
  final Function(String)? onSearch;
  final bool showSearchBar; // Toggle for search bar
  final String? backgroundImage;

  const SearchAppBar({
    Key? key,
    required this.title,
    this.leftIcon, // Made optional
    this.rightIcon, // Made optional
    this.onLeftTap, // Made optional
    this.onRightTap, // New optional callback
    this.leftWidget,
    this.rightWidget,
    this.recentSearches = const [],
    this.onRecentSelected,
    this.onRecentDelete,
    this.onSubmitted,
    this.onSearch,
    this.showSearchBar = true, // Default: show search bar
    this.backgroundImage,
  }) : super(key: key);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize =>
      Size.fromHeight(showSearchBar ? 140 : kToolbarHeight);
}

class _SearchAppBarState extends State<SearchAppBar> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _searchFieldKey = GlobalKey();
  OverlayEntry? _recentOverlay;

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          elevation: 0,
          backgroundColor: widget.backgroundImage != null ? Colors.transparent : null,
          flexibleSpace: widget.backgroundImage != null
              ? Container(
            height: kToolbarHeight + MediaQuery.of(context).padding.top,
            padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(widget.backgroundImage!),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.3),
                  BlendMode.darken,
                ),
              ),
            ),
          )
              : null,
          leading: widget.leftIcon != null
              ? IconButton(
            icon: Icon(widget.leftIcon,
                color: Colors.white),
            onPressed: widget.onLeftTap,
          )
              : widget.leftWidget ?? IconButton(
            icon: const Icon(Icons.arrow_back,
                color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: TextStyle(
                color: widget.backgroundImage != null ? Colors.white : Theme.of(context).colorScheme.onSurface,
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          centerTitle: true,
          actions: widget.rightIcon != null
              ? [
            IconButton(
              icon: Icon(widget.rightIcon,
                  color: widget.backgroundImage != null ? Colors.white : (isDarkMode ? Colors.white : Colors.black)),
              onPressed: widget.onRightTap,
            ),
          ]
              : widget.rightWidget != null ? [widget.rightWidget!] : [],
        ),
        if (widget.showSearchBar)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Theme(
                data: ThemeData(
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: isDarkMode ? Colors.white : Colors.black,
                  ),
                ),
                child: TextField(
                  key: _searchFieldKey,
                  controller: _searchController,
                  onTap: _handleSearchTap,
                  onChanged: (value) {
                    setState(() {});
                    _removeRecentOverlay();
                    widget.onSearch?.call(value);
                  },
                  onSubmitted: (query) {
                    _removeRecentOverlay();
                    widget.onSubmitted?.call(query);
                  },
                  decoration: InputDecoration(
                    hintText: "بحث...",
                    hintStyle: TextStyle(
                      color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                    ),
                    prefixIcon: Icon(Icons.search,
                        color: isDarkMode ? Colors.white : Colors.black54),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                      icon: Icon(Icons.clear, color: isDarkMode ? Colors.white : Colors.black54),
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                        _removeRecentOverlay();
                        widget.onSearch?.call('');
                      },
                    )
                        : null,
                    filled: true,
                    fillColor: isDarkMode ? Colors.grey[900] : Colors.grey[200],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  ),
                  style: TextStyle(color: isDarkMode ? Colors.white : Colors.black),
                ),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void didUpdateWidget(covariant SearchAppBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_recentOverlay != null &&
        !listEquals(oldWidget.recentSearches, widget.recentSearches)) {
      _removeRecentOverlay();
      if (widget.recentSearches.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            _showRecentOverlay();
          }
        });
      }
    }
  }

  @override
  void dispose() {
    _removeRecentOverlay();
    _searchController.dispose();
    super.dispose();
  }

  void _handleSearchTap() {
    if (widget.recentSearches.isEmpty) {
      _removeRecentOverlay();
      return;
    }
    _showRecentOverlay();
  }

  void _showRecentOverlay() {
    _removeRecentOverlay();

    final RenderBox? searchBox =
        _searchFieldKey.currentContext?.findRenderObject() as RenderBox?;
    final OverlayState? overlayState = Overlay.of(context);

    if (searchBox == null || overlayState == null) {
      return;
    }

    final Offset position = searchBox.localToGlobal(Offset.zero);
    final double top = position.dy + searchBox.size.height;

    _recentOverlay = OverlayEntry(
      builder: (context) {
        final theme = Theme.of(context);
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _removeRecentOverlay,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              top: top,
              left: 0,
              right: 0,
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Material(
                    color: Colors.transparent,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        borderRadius: BorderRadius.circular(18),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.12),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxHeight: 320),
                        child: ListView.separated(
                          shrinkWrap: true,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          itemCount: widget.recentSearches.length,
                          separatorBuilder: (_, __) => Divider(
                            height: 1,
                            color: theme.dividerColor.withOpacity(0.2),
                          ),
                          itemBuilder: (context, index) {
                            final term = widget.recentSearches[index];
                            return ListTile(
                              leading: const Icon(Icons.history),
                              title: Text(term),
                              trailing: IconButton(
                                icon: const Icon(Icons.close),
                                onPressed: () {
                                  widget.onRecentDelete?.call(term);
                                },
                              ),
                              onTap: () {
                                _removeRecentOverlay();
                                _searchController
                                  ..text = term
                                  ..selection = TextSelection.fromPosition(
                                      TextPosition(offset: term.length));
                                widget.onSearch?.call(term);
                                widget.onRecentSelected?.call(term);
                              },
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );

    overlayState.insert(_recentOverlay!);
  }

  void _removeRecentOverlay() {
    _recentOverlay?.remove();
    _recentOverlay = null;
  }
}

