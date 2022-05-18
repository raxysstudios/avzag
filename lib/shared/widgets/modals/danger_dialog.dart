import 'package:flutter/material.dart';

void showDangerDialog(
  BuildContext context,
  VoidCallback onConfirm,
  String title, {
  IconData confirmIcon = Icons.delete_rounded,
  String confirmText = 'Delete',
  IconData rejectIcon = Icons.edit_rounded,
  String rejectText = 'Keep',
}) {
  showDialog<void>(
    context: context,
    builder: (context) {
      final theme = Theme.of(context).colorScheme;
      return AlertDialog(
        title: Text(title),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
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
