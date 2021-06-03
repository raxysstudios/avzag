import 'package:avzag/dictionary/dictionary_page.dart';
import 'package:avzag/store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/home_page.dart';
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
  final Future<String> loader = Firebase.initializeApp()
      .then((_) => loadAll(null))
      .then((_) => SharedPreferences.getInstance())
      .then((prefs) => prefs.getString('module') ?? 'home');

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
      home: FutureBuilder<String>(
        future: loader,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? resolveBuilder(snapshot.data!)(context)
              : Scaffold(
                  body: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
        },
      ),
    );
  }
}
