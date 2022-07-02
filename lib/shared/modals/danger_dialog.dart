import 'package:auto_route/auto_route.dart';
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
  context.router.pushNativeRoute<void>(
    DialogRoute(
      context: context,
      builder: (context) {
        final theme = Theme.of(context).colorScheme;
        return AlertDialog(
          title: Text(title),
          actions: [
            TextButton.icon(
              onPressed: () {
                context.popRoute();
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
              onPressed: context.popRoute,
              icon: Icon(rejectIcon),
              label: Text(rejectText),
            ),
          ],
        );
      },
    ),
  );
}
