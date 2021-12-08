import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void showSnackbar(
  BuildContext context, {
  IconData icon = Icons.error_outline_outlined,
  String text = 'Error!',
  bool short = false,
}) {
  final theme = Theme.of(context);
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      duration: Duration(seconds: short ? 1 : 4),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      backgroundColor: theme.colorScheme.surface,
      content: Row(
        children: [
          Icon(icon),
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

void copyText(BuildContext context, String? text) async {
  if (text?.isNotEmpty ?? false) {
    await Clipboard.setData(
      ClipboardData(text: text),
    );
    showSnackbar(
      context,
      icon: Icons.content_copy_outlined,
      text: 'Copied to clipboard.',
      short: true,
    );
  }
}
