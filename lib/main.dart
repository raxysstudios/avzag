import 'package:avzag/firebase_builder.dart';
import 'package:avzag/home/models.dart';
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
  final Future<FirebaseApp> initializer = Firebase.initializeApp();

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
      home: FutureLoader(
        future: initializer,
        builder: () => HomePage(),
      ),
    );
  }
}
