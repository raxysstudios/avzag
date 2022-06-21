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
  final navigator = Navigator.of(context, rootNavigator: true);
  try {
    final result = await future;
    navigator.pop();
    return result;
  } catch (e) {
    navigator.pop();
    showSnackbar(context);
    rethrow;
  }
}
