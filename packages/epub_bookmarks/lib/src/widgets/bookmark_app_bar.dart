import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/bookmark_cubit.dart';

/// Simple AppBar for bookmark screen that can access BookmarkCubit
class BookmarkAppBar extends StatelessWidget implements PreferredSizeWidget {
  const BookmarkAppBar({
    super.key,
    required this.title,
    this.onDeleteTap,
    this.showDeleteButton = true,
  });

  final String title;
  final VoidCallback? onDeleteTap;
  final bool showDeleteButton;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      actions: showDeleteButton
          ? [
              IconButton(
                icon: const Icon(Icons.delete),
                onPressed: onDeleteTap ??
                    () {
                      // Access cubit from context (BlocProvider is outside Scaffold)
                      context.read<BookmarkCubit>().showClearDialog();
                    },
              ),
            ]
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

