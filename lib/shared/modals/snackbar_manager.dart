import 'package:flutter/material.dart';

void showSnackbar(
  BuildContext context, {
  IconData icon = Icons.error_outline_outlined,
  String text = 'Error!',
}) {
  ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 2500),
        behavior: SnackBarBehavior.floating,
        content: Row(
          children: [
            Icon(
              icon,
              color: Theme.of(context).colorScheme.onInverseSurface,
            ),
            const SizedBox(width: 16),
            Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
}
