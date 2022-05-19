import 'package:algolia/algolia.dart';
import 'package:avzag/store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'config/themes.dart';
import 'firebase_options.dart';
import 'modules/navigation/nav_drawer.dart';

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
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    final themes = Themes(Theme.of(context).colorScheme);
    return MaterialApp(
      title: 'Avzag',
      theme: themes.light,
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
