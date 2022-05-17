import 'package:flutter/material.dart';

import 'snackbar_manager.dart';

Future<T?> showLoadingDialog<T>(
  BuildContext context,
  Future<T?> future,
) async {
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return const Center(
        child: Card(
          shape: CircleBorder(),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: CircularProgressIndicator(),
          ),
        ),
      );
    },
  );
  try {
    final result = await future;
    Navigator.pop(context);
    return result;
  } catch (e) {
    // ignore: avoid_print
    print(e);
    Navigator.pop(context);
    showSnackbar(context);
    return null;
  }
}
