import 'package:avzag/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
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
              .then((_) {
                FirebaseFirestore.instance.settings = Settings(
                  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
                );
                FirebaseStorage.instance.setMaxOperationRetryTime(
                  Duration(milliseconds: 100),
                );
              })
              .then((_) => BaseStore.load(context))
              .then((_) => SharedPreferences.getInstance())
              .then((prefs) => prefs.getString('module') ?? 'home')
              .then((title) => navigate(context, title));
          return Scaffold();
        },
      ),
    );
  }
}
