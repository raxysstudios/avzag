import 'package:avzag/global_store.dart';
import 'package:avzag/widgets/raxys_logo.dart';
import 'package:flutter/material.dart';
import 'navigation/nav_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<ThemeData> getThemes(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final floatingActionButtonTheme = FloatingActionButtonThemeData(
      backgroundColor: colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
    );
    const cardTheme = CardTheme(
      clipBehavior: Clip.antiAlias,
    );
    const dividerTheme = DividerThemeData(space: 0);
    return [
      ThemeData().copyWith(
        scaffoldBackgroundColor: Colors.blueGrey.shade50,
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.grey,
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: colorScheme.surface,
          foregroundColor: colorScheme.onSurface,
        ),
        cardTheme: cardTheme,
        toggleableActiveColor: colorScheme.primary,
        floatingActionButtonTheme: floatingActionButtonTheme,
        dividerTheme: dividerTheme,
      ),
      ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          accentColor: Colors.grey,
          brightness: Brightness.dark,
        ),
        cardTheme: cardTheme,
        toggleableActiveColor: colorScheme.primary,
        floatingActionButtonTheme: floatingActionButtonTheme,
        dividerTheme: dividerTheme,
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
      home: FutureBuilder(
        future: Future.wait([
          Future.delayed(const Duration(seconds: 1)),
          GlobalStore.load(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            navigate(
              context,
              GlobalStore.prefs.getString('module') ?? 'home',
            );
          }
          return Material(
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  RaxysLogo(size: 256),
                  Text(
                    'ÆVZAG',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text('Made with honor in'),
                  Text(
                    'North Caucasus',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
