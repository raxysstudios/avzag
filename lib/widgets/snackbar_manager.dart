import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, [text = 'Error!']) {
  final theme = Theme.of(context);
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      backgroundColor: theme.colorScheme.surface,
      content: Row(
        children: [
          const Icon(Icons.error_outline_outlined),
          const SizedBox(width: 8),
          Text(
            text,
            style: theme.textTheme.bodyText1,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    ),
  );
}
