import 'dart:async';

import 'package:flutter/material.dart';

Future<T?> showDangerDialog<T>(
  BuildContext context,
  FutureOr<T> onConfirm,
  String title, {
  IconData confirmIcon = Icons.delete_rounded,
  String confirmText = 'Delete',
  IconData rejectIcon = Icons.edit_rounded,
  String rejectText = 'Keep',
}) {
  return showDialog<T>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context).colorScheme;
      return AlertDialog(
        title: Text(title),
        actions: [
          TextButton.icon(
            onPressed: () async => Navigator.pop(
              context,
              await onConfirm,
            ),
            icon: Icon(confirmIcon),
            label: Text(confirmText),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(theme.error),
              overlayColor: MaterialStateProperty.all(
                theme.error.withOpacity(0.1),
              ),
            ),
          ),
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(rejectIcon),
            label: Text(rejectText),
          ),
        ],
      );
    },
  );
}
