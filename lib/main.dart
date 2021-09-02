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

  List<ThemeData> getThemes(BuildContext context) {
    final floatingActionButtonTheme = FloatingActionButtonThemeData(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
    );
    final cardTheme = const CardTheme(
      clipBehavior: Clip.antiAlias,
    );
    return [
      ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.grey,
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        floatingActionButtonTheme: floatingActionButtonTheme,
        cardTheme: cardTheme,
      ),
      ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.grey,
        floatingActionButtonTheme: floatingActionButtonTheme,
        cardTheme: cardTheme,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final themes = getThemes(context);
    return MaterialApp(
      title: 'Avzag',
      theme: themes[0],
      darkTheme: themes[1],
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
