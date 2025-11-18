import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/bookmark_cubit.dart';
import '../models/bookmark_models.dart';

class BookmarkListWidget extends StatelessWidget {
  const BookmarkListWidget({
    super.key,
    required this.bookmarkList,
    required this.onBookmarkTap,
    required this.onRefresh,
  });

  final List<Bookmark> bookmarkList;
  final Future<void> Function(BuildContext context, Bookmark bookmark) onBookmarkTap;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    // Group the bookmarks by bookName
    final Map<String, List<Bookmark>> groupedBookmarks = {};
    for (final bookmark in bookmarkList) {
      groupedBookmarks
          .putIfAbsent(bookmark.bookName, () => [])
          .add(bookmark);
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
            ...bookBookmarks.map((bookmark) {
              final String stringValue = bookmark.pageIndex;
              final double doubleValue = double.parse(stringValue);
              final int intValue = doubleValue.toInt();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    GestureDetector(
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
                            child: const CircleAvatar(
                              radius: 12,
                              child: Icon(
                                Icons.close_rounded,
                                size: 16,
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
                                    .labelSmall,
                                textAlign: TextAlign.right,
                              ),
                            ),
                          ),
                          Text(
                            (intValue + 1).toString(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall,
                          ),
                        ],
                      ),
                    ),
                    if (bookBookmarks.indexOf(bookmark) <
                        bookBookmarks.length - 1)
                      const Divider(
                        height: 0.5,
                      ),
                  ],
                ),
              );
            }),
          ],
        );
      },
    );
  }
}

