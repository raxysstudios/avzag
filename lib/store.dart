import 'package:avzag/dictionary/store.dart';
import 'package:avzag/home/store.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? editorMode;

Future<void> loadAll() async {
  List<String> langs = await SharedPreferences.getInstance().then(
    (prefs) => prefs.getStringList('languages') ?? [],
  );
  await Future.wait([
    homeLoader.load(langs),
    dictionaryLoader.load(langs),
  ]);
}

class ModuleLoader {
  Future<void>? loader;
  final Future<void> Function(List<String> languages) load;

  ModuleLoader(this.load);

  void start(List<String> languages) {
    loader = load(languages);
  }
}
