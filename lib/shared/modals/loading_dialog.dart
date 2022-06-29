import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

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
    print('DLG $result.');
    Navigator.pop(context);
    return result;
  } catch (e) {
    Navigator.pop(context);
    showSnackbar(context);
    rethrow;
  }
}

Future<T?> showLoadingDialog2<T>(
  BuildContext context,
  Future<T?> future,
) {
  return context.router.pushNativeRoute<T?>(
    DialogRoute(
      context: context,
      builder: (context) {
        return FutureBuilder(
          future: future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              SchedulerBinding.instance.addPostFrameCallback(
                (_) {
                  if (snapshot.hasError) {
                    context.popRoute(context);
                    showSnackbar(context);
                  } else {
                    context.popRoute(snapshot.data);
                  }
                },
              );
            }
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
      },
    ),
  );
}
