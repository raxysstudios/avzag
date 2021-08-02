import 'package:flutter/material.dart';

void showLoadingDialog<T>(
  BuildContext context,
  Future<T> future,
  ValueSetter<T?> callback,
) =>
    showDialog<T>(
      context: context,
      builder: (context) {
        future.then(
          (result) => Navigator.pop(context, result),
        );
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
    ).then((result) {
      if (result != null) callback(result);
    });
