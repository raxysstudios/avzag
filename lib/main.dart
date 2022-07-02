import 'package:algolia/algolia.dart';
import 'package:avzag/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_strategy/url_strategy.dart';

import 'firebase_options.dart';
import 'modules/navigation/services/root_guard.dart';
import 'modules/navigation/services/router.gr.dart';
import 'theme_set.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  prefs = await SharedPreferences.getInstance();
  algolia = const Algolia.init(
    applicationId: 'NYVVAA43NI',
    apiKey: 'cf52a68ac340fc555978892202ce37df',
  );
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAuth.instance.authStateChanges().first;
  await EditorStore.init();
  GlobalStore.init();
  setPathUrlStrategy();
  runApp(App());
}

class App extends StatelessWidget {
  App({Key? key}) : super(key: key);

  final _appRouter = AppRouter(rootGuard: RootGuard());

  @override
  Widget build(context) {
    final theme = ThemeSet(Theme.of(context).colorScheme);
    return MaterialApp.router(
      title: 'Avzag',
      theme: theme.light,
      darkTheme: theme.dark,
      routerDelegate: _appRouter.delegate(),
      routeInformationParser: _appRouter.defaultRouteParser(),
    );
  }
}
