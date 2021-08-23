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
      home: Builder(
        builder: (context) {
          GlobalStore.load(context)
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
