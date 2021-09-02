import 'package:avzag/global_store.dart';
import 'package:avzag/widgets/loading_card.dart';
import 'package:flutter/material.dart';
import 'navigation/nav_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(App());
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final loader = GlobalStore.load();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Avzag',
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.grey,
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        cardTheme: CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.grey,
        cardTheme: CardTheme(
          clipBehavior: Clip.antiAlias,
        ),
      ),
      home: Scaffold(
        body: FutureBuilder(
          future: loader,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done)
              Future.delayed(
                Duration(milliseconds: 10),
                () => navigate(
                  context,
                  GlobalStore.prefs.getString('module') ?? 'home',
                ),
              );
            return LoadingCard();
          },
        ),
      ),
    );
  }
}
