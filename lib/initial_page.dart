import 'package:avzag/config/themes.dart';
import 'package:avzag/store.dart';
import 'package:flutter/material.dart';
import 'package:navigation_history_observer/navigation_history_observer.dart';

import 'modules/navigation/nav_drawer.dart';

class InitialPage extends StatelessWidget {
  const InitialPage({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    final themes = Themes(Theme.of(context).colorScheme);
    return MaterialApp(
      title: 'Avzag',
      theme: themes.light,
      navigatorObservers: [NavigationHistoryObserver()],
      darkTheme: themes.dark,
      home: FutureBuilder<void>(
        future: Future.value(),
        builder: (context, snapshot) {
          navigate(
            context,
            prefs.getString('module') ?? 'home',
          );
          return const Material();
        },
      ),
    );
  }
}
