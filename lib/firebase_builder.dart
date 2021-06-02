import 'package:flutter/material.dart';

class FutureLoader extends StatelessWidget {
  final Future<void>? future;
  final Widget Function()? builder;

  const FutureLoader({
    this.future,
    this.builder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        if (snapshot.hasError)
          return Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.error_outline_sharp),
                SizedBox(height: 16),
                Text("Something went wrong."),
              ],
            ),
          );
        if (snapshot.connectionState != ConnectionState.done)
          return Material(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 16),
                Text("Loading, please wait..."),
              ],
            ),
          );
        return builder?.call() ?? Offstage();
      },
    );
  }
}
