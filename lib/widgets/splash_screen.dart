import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'raxys_logo.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({
    required this.title,
    required this.future,
    required this.onLoaded,
    this.minDuration = const Duration(seconds: 1),
    Key? key,
  }) : super(key: key);

  final Duration minDuration;
  final String title;
  final Future<void> future;
  final void Function(BuildContext) onLoaded;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.wait<void>([
        Future.delayed(minDuration),
        future,
      ]),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          SchedulerBinding.instance?.addPostFrameCallback(
            (_) => onLoaded(context),
          );
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
