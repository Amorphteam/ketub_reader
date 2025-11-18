import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cupertino_native/cupertino_native.dart';
import 'cubit/bookmark_cubit.dart';
import 'cubit/bookmark_state.dart';
import 'models/bookmark_models.dart';
import 'models/bookmark_persistence.dart';
import 'widgets/bookmark_list_widget.dart';
import 'widgets/history_list_widget.dart';
import 'widgets/bookmark_app_bar.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({
    super.key,
    required this.persistence,
    this.appBar,
    this.onBookmarkTap,
    this.onHistoryTap,
    this.emptyBookmarkTitle,
    this.emptyBookmarkSubtitle,
    this.emptyHistoryTitle,
    this.emptyHistorySubtitle,
    this.clearDialogTitle,
    this.clearDialogContent,
    this.clearDialogCancelText,
    this.clearDialogConfirmText,
  });

  final BookmarkPersistence persistence;
  final PreferredSizeWidget? appBar;
  final Future<void> Function(BuildContext context, Bookmark bookmark)? onBookmarkTap;
  final Future<void> Function(BuildContext context, History history)? onHistoryTap;
  final String? emptyBookmarkTitle;
  final String? emptyBookmarkSubtitle;
  final String? emptyHistoryTitle;
  final String? emptyHistorySubtitle;
  final String? clearDialogTitle;
  final String? clearDialogContent;
  final String? clearDialogCancelText;
  final String? clearDialogConfirmText;

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  // Store previous state to preserve content when dialog is shown
  BookmarkState? _previousState;

  @override
  Widget build(BuildContext context) => BlocProvider(
    create: (context) => BookmarkCubit(persistence: widget.persistence),
    child: Scaffold(
      appBar: widget.appBar ?? _buildDefaultAppBar(),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: BlocListener<BookmarkCubit, BookmarkState>(
          listener: (context, state) {
            state.maybeWhen(
              bookmarkTapped: (bookmark, segment) async {
                await widget.onBookmarkTap?.call(context, bookmark);
                // Reset state after navigation to prevent re-navigation on back
                context.read<BookmarkCubit>().dismissNavigation();
              },
              historyTapped: (history, segment) async {
                await widget.onHistoryTap?.call(context, history);
                // Reset state after navigation to prevent re-navigation on back
                context.read<BookmarkCubit>().dismissNavigation();
              },
              showClearDialog: (segment, selectedSeg) {
                _showClearDialog(context, selectedSeg);
              },
              orElse: () {},
            );
          },
          child: BlocBuilder<BookmarkCubit, BookmarkState>(
            builder: (context, state) {
              // Store previous state if not showClearDialog
              if (!state.maybeWhen(
                showClearDialog: (_, __) => true,
                orElse: () => false,
              )) {
                _previousState = state;
              }

              final selectedSegment = state.maybeWhen(
                initial: (segment) => segment,
                loading: (segment) => segment,
                bookmarksLoaded: (_, segment) => segment,
                historyLoaded: (_, segment) => segment,
                bookmarkTapped: (_, segment) => segment,
                historyTapped: (_, segment) => segment,
                showClearDialog: (segment, selectedSeg) => selectedSeg,
                error: (_, segment) => segment,
                orElse: () => BookmarkSegment.bookmark,
              );

              final selectedIndex = selectedSegment == BookmarkSegment.bookmark ? 0 : 1;

              // Use previous state for body if current state is showClearDialog
              final stateForBody = state.maybeWhen(
                showClearDialog: (_, __) => _previousState ?? state,
                orElse: () => state,
              );

              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Platform.isIOS
                        ? CNSegmentedControl(
                            labels: const ['الإشارات', 'السجل'],
                            selectedIndex: selectedIndex,
                            onValueChanged: (index) {
                              final segment = index == 0
                                  ? BookmarkSegment.bookmark
                                  : BookmarkSegment.history;
                              context.read<BookmarkCubit>().switchSegment(segment);
                            },
                          )
                        : SegmentedButton<BookmarkSegment>(
                            segments: [
                              ButtonSegment(
                                value: BookmarkSegment.bookmark,
                                label: const Text('الإشارات'),
                                icon: const Icon(Icons.bookmark),
                              ),
                              ButtonSegment(
                                value: BookmarkSegment.history,
                                label: const Text('السجل'),
                                icon: const Icon(Icons.history),
                              ),
                            ],
                            selected: {selectedSegment},
                            showSelectedIcon: false,
                            onSelectionChanged: (newSelection) {
                              context
                                  .read<BookmarkCubit>()
                                  .switchSegment(newSelection.first);
                            },
                          ),
                  ),
                  Expanded(
                    child: _buildBody(context, stateForBody, selectedSegment),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    ),
  );

  PreferredSizeWidget _buildDefaultAppBar() {
    return BookmarkAppBar(
      title: 'Bookmarks',
    );
  }

  void _showClearDialog(BuildContext context, BookmarkSegment segment) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            title: Text(widget.clearDialogTitle ?? 'تأكيد الحذف'),
            content: Text(widget.clearDialogContent ?? 'هل أنت متأكد أنك تريد حذف جميع البيانات؟'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.read<BookmarkCubit>().dismissClearDialog();
                },
                child: Text(widget.clearDialogCancelText ?? 'إلغاء'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(dialogContext).pop();
                  context.read<BookmarkCubit>().clearAll();
                },
                child: Text(widget.clearDialogConfirmText ?? 'حذف'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBody(BuildContext context, BookmarkState state, BookmarkSegment selectedSegment) {
    return state.when(
      initial: (_) => const Center(child: Text('Initializing...')),
      loading: (_) => const Center(child: CircularProgressIndicator()),
      bookmarksLoaded: (bookmarks, _) {
        if (selectedSegment != BookmarkSegment.bookmark) {
          return const SizedBox.shrink();
        }
        if (bookmarks.isEmpty) {
          return _buildEmptyMessage(
            title: widget.emptyBookmarkTitle ?? 'قائمة الإشارات المرجعية فارغة',
            subtitle: widget.emptyBookmarkSubtitle ?? 'يمكنك إضافة إشارات مرجعية من الكتب التي تقرأها.',
          );
        }
        return BookmarkListWidget(
          bookmarkList: bookmarks,
          onBookmarkTap: (ctx, bookmark) async {
            context.read<BookmarkCubit>().openEpubFromBookmark(bookmark);
            // Navigation will be handled by BlocListener
          },
          onRefresh: () => context.read<BookmarkCubit>().refresh(),
        );
      },
      historyLoaded: (history, _) {
        if (selectedSegment != BookmarkSegment.history) {
          return const SizedBox.shrink();
        }
        if (history.isEmpty) {
          return _buildEmptyMessage(
            title: widget.emptyHistoryTitle ?? 'قائمة السجل فارغة',
            subtitle: widget.emptyHistorySubtitle ?? 'يمكنك مراجعة السجل هنا.',
          );
        }
        return HistoryListWidget(
          historyList: history,
          onHistoryTap: (ctx, history) async {
            context.read<BookmarkCubit>().openEpubFromHistory(history);
            // Navigation will be handled by BlocListener
          },
          onRefresh: () => context.read<BookmarkCubit>().refresh(),
        );
      },
      bookmarkTapped: (_, __) => const SizedBox.shrink(),
      historyTapped: (_, __) => const SizedBox.shrink(),
      showClearDialog: (segment, selectedSeg) {
        // This should never be reached since we use previousState
        return const SizedBox.shrink();
      },
      error: (message, _) => Center(child: Text(message)),
    );
  }

  Widget _buildEmptyMessage({required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(top: 100.0),
      child: Container(
        height: MediaQuery.of(context).size.height / 3,
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height: 120),
              Text(
                title,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

