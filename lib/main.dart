import 'package:avzag/store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'navigation/nav_drawer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        cardTheme: CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
      ),
      home: Builder(
        builder: (context) {
          Firebase.initializeApp()
              .then((_) => BaseStore.load(context))
              .then((_) => SharedPreferences.getInstance())
              .then((prefs) => prefs.getString('module') ?? 'home')
              .then((title) => navigate(context, 'home'));
          return Scaffold();
        },
      ),
    );
  }
}
