import 'package:flutter/material.dart';

Future<bool> showDangerDialog(
  BuildContext context,
  String title, {
  VoidCallback? onConfirm,
  confirmText = 'Delete',
  rejectText = 'Keep',
}) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(context, true);
              onConfirm?.call();
            },
            icon: Icon(Icons.delete_outlined),
            label: Text(confirmText),
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all(Colors.red),
              overlayColor: MaterialStateProperty.all(Colors.red.shade50),
            ),
          ),
          TextButton.icon(
            onPressed: () => Navigator.pop(context),
            icon: Icon(Icons.edit_outlined),
            label: Text(rejectText),
          ),
        ],
      );
    },
  ).then((value) => value ?? false);
}
