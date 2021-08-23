import 'package:flutter/material.dart';

void showSnackbar(BuildContext context, [text = 'Error!']) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.hideCurrentSnackBar();
  messenger.showSnackBar(
    SnackBar(
      content: Row(
        children: [
          Icon(
            Icons.error_outlined,
            color: Colors.white,
          ),
          SizedBox(width: 8),
          Text(
            text,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ],
      ),
    ),
  );
}
