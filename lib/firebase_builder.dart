import 'package:flutter/material.dart';

class FutureLoader extends StatelessWidget {
  final Future<void>? future;
  final Widget Function(Widget? body) builder;
  final Widget Function(Widget? body)? errorBuilder;
  final Widget Function()? body;

  const FutureLoader({
    this.future,
    required this.builder,
    this.body,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        Widget? body;
        if (snapshot.hasError)
          body = Center(
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
        else if (snapshot.connectionState != ConnectionState.done)
          body = Center(
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

        if (body != null && errorBuilder != null) return errorBuilder!(body);
        if (body == null && this.body != null) body = this.body!();
        return builder.call(body);
      },
    );
  }
}
