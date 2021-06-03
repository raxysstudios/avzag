import 'package:avzag/store.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home/home_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final Future<void> loader =
      Firebase.initializeApp().then((value) => loadAll(null));

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
      home: FutureBuilder(
        future: loader,
        builder: (context, snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? HomePage()
              : Offstage();
        },
      ),
    );
  }
}
