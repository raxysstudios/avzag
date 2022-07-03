import 'dart:async';

import 'package:avzag/shared/modals/loading_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class LoaderScreen<T> extends StatefulWidget {
  const LoaderScreen(
    this.future, {
    required this.then,
    Key? key,
  }) : super(key: key);

  final Future<T?> future;
  final void Function(BuildContext, T?) then;

  @override
  State<LoaderScreen<T>> createState() => _LoaderScreenState<T>();
}

class _LoaderScreenState<T> extends State<LoaderScreen<T>> {
  T? result;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback(
      (_) async {
        widget.then(
          context,
          await showLoadingDialog(context, widget.future),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}
