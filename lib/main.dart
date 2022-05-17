import 'package:avzag/global_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'navigation/nav_drawer.dart';
import 'utils/themes.dart';

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
    final themes = getThemes(context);
    return MaterialApp(
      title: 'Avzag',
      theme: themes.light,
      darkTheme: themes.dark,
      home: FutureBuilder(
        future: GlobalStore.load(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            navigate(
              context,
              GlobalStore.prefs.getString('module') ?? 'home',
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
