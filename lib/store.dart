import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'models/language.dart';
import 'shared/utils/utils.dart';

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

  static Future _check(User? user) async {
    if (user == null) {
      adminable.clear();
      language = null;
      return;
    }
    final token = await user.getIdTokenResult(true);
    adminable = json2list(token.claims?['admin']) ?? [];
  }

  static Future _init() async {
    _language = prefs.getString('editorLanguage');
    _check(user);
    FirebaseAuth.instance.userChanges().listen(_check);
  }
}

class GlobalStore {
  static Map<String, Language?> languages = {};

  static Future<void> set({
    Iterable<String>? names,
    Iterable<Language>? objects,
  }) async {
    if (objects != null) {
      languages = {for (final l in objects) l.name: l};
    } else if (names != null) {
      languages = {for (final l in names) l: null};
    }
    if (!languages.containsKey(EditorStore.language)) {
      EditorStore.language = null;
    }
    prefs.setStringList('languages', languages.keys.toList());
  }

  static Future<void> _load([List<String>? names]) async {
    set(
      names: names ?? prefs.getStringList('languages') ?? ['iron'],
    );

    for (final l in languages.keys) {
      FirebaseFirestore.instance
          .doc('languages/$l')
          .withConverter(
            fromFirestore: (snapshot, _) => Language.fromJson(snapshot.data()!),
            toFirestore: (_, __) => {},
          )
          .get()
          .then((r) {
        final l = r.data();
        if (l != null) languages[l.name] = l;
      });
    }
  }

  static Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    prefs = await SharedPreferences.getInstance();
    algolia = const Algolia.init(
      applicationId: 'NYVVAA43NI',
      apiKey: 'cf52a68ac340fc555978892202ce37df',
    );
    await EditorStore._init();
    await _load();
  }
}
