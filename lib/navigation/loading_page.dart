import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoadingPage<T> extends StatelessWidget {
  const LoadingPage(
    this.future, {
    required this.then,
    Key? key,
  }) : super(key: key);

  final Future<T?> future;
  final FutureOr Function(BuildContext, T?) then;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T?>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          SchedulerBinding.instance.addPostFrameCallback(
            (_) async {
              await then(context, snapshot.data);
              context.popRoute();
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(
            color: Theme.of(context).colorScheme.surface,
          ),
        );
      },
    );
  }
}
