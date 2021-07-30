import 'package:flutter/material.dart';

Future<void> showLoadingDialog({
  required BuildContext context,
  required Future future,
  String text = 'Loading, please wait...',
}) async {
  return await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      future.then((_) => Navigator.pop(context));
      return WillPopScope(
        onWillPop: () async => false,
        child: AlertDialog(
          contentPadding: const EdgeInsets.all(0),
          content: Container(
            height: 128,
            width: 128,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text(text),
              ],
            ),
          ),
        ),
      );
    },
  );
}
