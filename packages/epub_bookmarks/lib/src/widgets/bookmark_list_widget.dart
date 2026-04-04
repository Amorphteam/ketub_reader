import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/bookmark_cubit.dart';
import '../models/bookmark_models.dart';

const double _tocBaseFontSize = 18.0;

class BookmarkListWidget extends StatelessWidget {
  const BookmarkListWidget({
    super.key,
    required this.bookmarkList,
    this.groupResultsByBookName = true,
    this.itemUseCard = false,
    this.showItemPageNumber = true,
    this.itemCardColor,
    required this.onBookmarkTap,
    required this.onRefresh,
  });

  final List<Bookmark> bookmarkList;
  final bool groupResultsByBookName;
  /// When true, each row is a flat [Card] instead of a plain row + [Divider].
  final bool itemUseCard;
  /// When false, the page index is not shown on the right.
  final bool showItemPageNumber;
  /// Background for each item [Card] when [itemUseCard] is true.
  final Color? itemCardColor;
  final Future<void> Function(BuildContext context, Bookmark bookmark) onBookmarkTap;
  final VoidCallback onRefresh;

  int _pageDisplay(Bookmark bookmark) {
    final double doubleValue = double.parse(bookmark.pageIndex);
    return doubleValue.toInt();
  }

  Widget _buildRow(BuildContext context, Bookmark bookmark) {
    final int intValue = _pageDisplay(bookmark);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        onBookmarkTap(context, bookmark);
        onRefresh();
      },
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              context.read<BookmarkCubit>().deleteBookmark(bookmark.id!);
            },
            child: CircleAvatar(
              radius: 12,
              backgroundColor: Theme.of(context).colorScheme.primary,
              child: Icon(
                Icons.close_rounded,
                size: 16,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                bookmark.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontSize: _tocBaseFontSize),
                textAlign: TextAlign.right,
              ),
            ),
          ),
          if (showItemPageNumber)
            Text(
              (intValue + 1).toString(),
              style: Theme.of(context).textTheme.titleSmall,
            ),
        ],
      ),
    );
  }

  Widget _wrapItem(
    BuildContext context,
    Widget row, {
    required bool showDividerAfter,
  }) {
    if (itemUseCard) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Card(
          elevation: 0,
          shadowColor: Colors.transparent,
          surfaceTintColor: Colors.transparent,
          color: itemCardColor,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: row,
          ),
        ),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: row,
        ),
        if (showDividerAfter) const Divider(height: 0.5),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!groupResultsByBookName) {
      return ListView.builder(
        padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
        itemCount: bookmarkList.length,
        itemBuilder: (context, index) {
          final bookmark = bookmarkList[index];
          final row = _buildRow(context, bookmark);
          final last = index == bookmarkList.length - 1;
          return _wrapItem(
            context,
            row,
            showDividerAfter: !itemUseCard && !last,
          );
        },
      );
    }

    final Map<String, List<Bookmark>> groupedBookmarks = {};
    for (final bookmark in bookmarkList) {
      groupedBookmarks.putIfAbsent(bookmark.bookName, () => []).add(bookmark);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
      itemCount: groupedBookmarks.length,
      itemBuilder: (context, bookIndex) {
        final bookName = groupedBookmarks.keys.elementAt(bookIndex);
        final bookBookmarks = groupedBookmarks[bookName]!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Card(
              child: SizedBox(
                width: double.infinity,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Text(
                    textAlign: TextAlign.right,
                    bookName,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                ),
              ),
            ),
            ...bookBookmarks.asMap().entries.map((entry) {
              final i = entry.key;
              final bookmark = entry.value;
              final row = _buildRow(context, bookmark);
              final last = i == bookBookmarks.length - 1;
              return _wrapItem(
                context,
                row,
                showDividerAfter: !itemUseCard && !last,
              );
            }),
          ],
        );
      },
    );
  }
}
