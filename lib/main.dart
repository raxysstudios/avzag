import 'package:algolia/algolia.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/widgets/loading_card.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'navigation/nav_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  GlobalStore.algolia = Algolia.init(
    applicationId: 'NYVVAA43NI',
    apiKey: 'cf52a68ac340fc555978892202ce37df',
  );
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avzag',
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        cardTheme: CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
      ),
      // darkTheme: ThemeData(
      //   brightness: Brightness.dark,
      //   accentColor: Colors.grey,
      //   cardTheme: CardTheme(
      //     clipBehavior: Clip.antiAlias,
      //   ),
      // ),
      home: Builder(
        builder: (context) {
          Firebase.initializeApp()
              .then((_) => GlobalStore.load(context))
              .then((_) => GlobalStore.prefs.getString('module') ?? 'home')
              .then((title) => navigate(context, title));
          return Scaffold(
            body: LoadingCard(),
          );
        },
      ),
    );
  }
}
