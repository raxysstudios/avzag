import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class LoadingPage<T> extends StatelessWidget {
  const LoadingPage(
    this.future,
    this.route, {
    Key? key,
  }) : super(key: key);

  final Future<T> future;
  final PageRouteInfo Function(T?) route;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          context.replaceRoute(route(snapshot.data));
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
