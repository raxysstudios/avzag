import 'package:avzag/store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'config/themes.dart';
import 'modules/navigation/nav_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(context) {
    final themes = Themes(Theme.of(context).colorScheme);
    return MaterialApp(
      title: 'Avzag',
      theme: themes.light,
      darkTheme: themes.dark,
      home: FutureBuilder(
        future: GlobalStore.init(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            navigate(
              context,
              GlobalStore.prefs.getString('module') ?? 'home',
            );
          }
          return const Material();
        },
      ),
    );
  }
}
