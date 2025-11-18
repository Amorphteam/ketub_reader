import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/bookmark_cubit.dart';
import '../models/bookmark_models.dart';

class HistoryListWidget extends StatelessWidget {
  const HistoryListWidget({
    super.key,
    required this.historyList,
    required this.onHistoryTap,
    required this.onRefresh,
  });

  final List<History> historyList;
  final Future<void> Function(BuildContext context, History history) onHistoryTap;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final Map<String, List<History>> groupedHistory = {};
    for (final history in historyList) {
      groupedHistory
          .putIfAbsent(history.bookName, () => [])
          .add(history);
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: 16.0, right: 8.0, left: 8.0),
      itemCount: groupedHistory.length,
      itemBuilder: (context, bookIndex) {
        final bookName = groupedHistory.keys.elementAt(bookIndex);
        final bookHistory = groupedHistory[bookName]!;

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
            ...bookHistory.map((history) {
              final String stringValue = history.pageIndex;
              final double doubleValue = double.parse(stringValue);
              final int intValue = doubleValue.toInt();

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        onHistoryTap(context, history);
                        onRefresh();
                      },
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              context.read<BookmarkCubit>().deleteHistory(history.id!);
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
                                history.title,
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
                    if (bookHistory.indexOf(history) <
                        bookHistory.length - 1)
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

