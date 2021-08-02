import 'package:flutter/material.dart';

void showLoadingDialog<T>(
  BuildContext context,
  Future<T> future,
  ValueSetter<T?> callback,
) {
  var cancelled = false;
  showDialog(
    context: context,
    builder: (context) {
      return Center(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(128),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(),
            ),
          ),
        ),
      );
    },
  ).then((_) => cancelled = true);
  future.then((result) {
    if (!cancelled) {
      Navigator.pop(context);
      callback(result);
    }
  });
}
