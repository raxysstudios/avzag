import 'package:algolia/algolia.dart';
import 'package:avzag/navigation/root_guard.dart';
import 'package:avzag/store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'themes.dart';
import 'firebase_options.dart';
import 'navigation/router.gr.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  prefs = await SharedPreferences.getInstance();
  algolia = const Algolia.init(
    applicationId: 'NYVVAA43NI',
    apiKey: 'cf52a68ac340fc555978892202ce37df',
  );
  await EditorStore.init();
  await GlobalStore.init();
  setPathUrlStrategy();
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _appRouter = AppRouter(rootGuard: RootGuard());

  @override
  Widget build(context) {
    final themes = Themes(Theme.of(context).colorScheme);
    return MaterialApp.router(
      title: 'Avzag',
      theme: themes.light,
      darkTheme: themes.dark,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
