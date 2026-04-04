import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/bookmark_cubit.dart';
import '../models/bookmark_models.dart';

const double _tocBaseFontSize = 18.0;

class HistoryListWidget extends StatelessWidget {
  const HistoryListWidget({
    super.key,
    required this.historyList,
    this.groupResultsByBookName = true,
    this.itemUseCard = false,
    this.showItemPageNumber = true,
    this.itemCardColor,
    required this.onHistoryTap,
    required this.onRefresh,
  });

  final List<History> historyList;
  final bool groupResultsByBookName;
  final bool itemUseCard;
  final bool showItemPageNumber;
  final Color? itemCardColor;
  final Future<void> Function(BuildContext context, History history) onHistoryTap;
  final VoidCallback onRefresh;

  int _pageDisplay(History history) {
    final double doubleValue = double.parse(history.pageIndex);
    return doubleValue.toInt();
  }

  Widget _buildRow(BuildContext context, History history) {
    final int intValue = _pageDisplay(history);
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
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
                history.title,
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
        itemCount: historyList.length,
        itemBuilder: (context, index) {
          final history = historyList[index];
          final row = _buildRow(context, history);
          final last = index == historyList.length - 1;
          return _wrapItem(
            context,
            row,
            showDividerAfter: !itemUseCard && !last,
          );
        },
      );
    }

    final Map<String, List<History>> groupedHistory = {};
    for (final history in historyList) {
      groupedHistory.putIfAbsent(history.bookName, () => []).add(history);
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
            ...bookHistory.asMap().entries.map((entry) {
              final i = entry.key;
              final history = entry.value;
              final row = _buildRow(context, history);
              final last = i == bookHistory.length - 1;
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
