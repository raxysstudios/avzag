import 'package:algolia/algolia.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'shared/utils.dart';

late final Algolia algolia;
late final SharedPreferences prefs;

class EditorStore {
  static List<String> adminable = [];

  static String? _language;
  static String? get language => _language;
  static set language(String? value) {
    _language = value;
    if (value == null) {
      prefs.remove('editorLanguage');
    } else {
      prefs.setString('editorLanguage', value);
    }
  }

  static User? get user => FirebaseAuth.instance.currentUser;
  static bool get editor => user != null && language != null;
  static bool get admin => editor && adminable.contains(language);

  static Future<List<String>> getAdminable() async {
    final token = await user?.getIdTokenResult(true);
    return json2list(token?.claims?['admin']) ?? [];
  }

  static void _check(User? user) async {
    if (user == null) {
      adminable.clear();
      language = null;
      return;
    }
    adminable = await getAdminable();
  }

  static Future<void> init() async {
    _language = prefs.getString('editorLanguage');
    adminable = await getAdminable();
    FirebaseAuth.instance.userChanges().listen(_check);
  }
}

class GlobalStore {
  static var languages = <String>[];

  static void set(List<String> languages) {
    GlobalStore.languages = [...languages];
    if (!languages.contains(EditorStore.language)) {
      EditorStore.language = null;
    }
    prefs.setStringList('languages', languages);
  }

  static void init([List<String>? names]) =>
      set(prefs.getStringList('languages') ?? ['aghul']);
}
