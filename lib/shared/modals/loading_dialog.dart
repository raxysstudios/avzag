import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'snackbar_manager.dart';

Future<T?> showLoadingDialog<T>(
  BuildContext context,
  Future<T?> future,
) {
  var done = false;
  return context.router.pushNativeRoute<T?>(
    DialogRoute(
      context: context,
      builder: (context) {
        return Center(
          child: Card(
            shape: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: FutureBuilder(
                future: future,
                builder: (context, snapshot) {
                  if (!done &&
                      snapshot.connectionState == ConnectionState.done) {
                    done = true;
                    SchedulerBinding.instance.addPostFrameCallback(
                      (_) {
                        if (snapshot.hasError) {
                          context.popRoute();
                          showSnackbar(context);
                        } else {
                          context.popRoute(snapshot.data);
                        }
                      },
                    );
                  }
                  return const CircularProgressIndicator();
                },
              ),
            ),
          ),
        );
      },
    ),
  );
}
