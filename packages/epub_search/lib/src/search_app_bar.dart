import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Search AppBar widget with the same UI as CustomAppBar
/// This is a self-contained version to break dependencies
class SearchAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leftWidget;
  final Widget? rightWidget;
  final VoidCallback? onLeftTap;
  final List<String> recentSearches;
  final ValueChanged<String>? onRecentSelected;
  final ValueChanged<String>? onRecentDelete;
  final Function(String)? onSubmitted;
  final Function(String)? onSearch;

  const SearchAppBar({
    Key? key,
    required this.title,
    this.leftWidget,
    this.rightWidget,
    this.onLeftTap,
    this.recentSearches = const [],
    this.onRecentSelected,
    this.onRecentDelete,
    this.onSubmitted,
    this.onSearch,
  }) : super(key: key);

  @override
  State<SearchAppBar> createState() => _SearchAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(140);
}

class _SearchAppBarState extends State<SearchAppBar> {
  final TextEditingController _searchController = TextEditingController();
  final GlobalKey _searchFieldKey = GlobalKey();
  OverlayEntry? _recentOverlay;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppBar(
          elevation: 0,
          leading: widget.leftWidget ??
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
          title: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              widget.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          centerTitle: true,
          actions: widget.rightWidget != null ? [widget.rightWidget!] : [],
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
          child: Directionality(
            textDirection: TextDirection.rtl,
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
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {});
                          _removeRecentOverlay();
                          widget.onSearch?.call('');
                        },
                      )
                    : null,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(14),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
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

