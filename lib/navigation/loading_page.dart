import 'dart:async';

import 'package:auto_route/auto_route.dart';
import 'package:avzag/shared/modals/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoadingPage<T> extends StatefulWidget {
  const LoadingPage(
    this.future, {
    required this.then,
    Key? key,
  }) : super(key: key);

  final Future<T?> future;
  final FutureOr<PageRouteInfo?> Function(BuildContext, T?) then;

  @override
  State<LoadingPage<T>> createState() => _LoadingPageState<T>();
}

class _LoadingPageState<T> extends State<LoadingPage<T>> {
  T? result;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        final next = await widget.then(
          context,
          await showLoadingDialog(context, widget.future),
        );
        if (next == null) {
          context.popRoute();
        } else {
          context.navigateTo(next);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
