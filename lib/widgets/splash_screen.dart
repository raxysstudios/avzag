import 'package:flutter/material.dart';

import 'raxys_logo.dart';

class SplashScreen<T> extends StatelessWidget {
  const SplashScreen({
    required this.title,
    required this.future,
    required this.onLoaded,
    Key? key,
  }) : super(key: key);

  final String title;
  final Future<T> future;
  final Future<void> Function(BuildContext, T?) onLoaded;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          onLoaded(context, snapshot.data);
        }
        return Material(
          child: SafeArea(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const RaxysLogo(size: 256),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text('Made with honor in'),
                const Text(
                  'North Caucasus',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
