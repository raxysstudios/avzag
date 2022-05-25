import 'package:auto_route/auto_route.dart';
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
    // Navigator.pop(context);
    Navigator.of(context, rootNavigator: true).pop(result);
    return result;
  } catch (e) {
    // Navigator.pop(context);
    Navigator.of(context, rootNavigator: true).pop();
    showSnackbar(context);
    rethrow;
  }
}
