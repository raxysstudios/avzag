import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'firebase_options.dart';
import 'models/language.dart';
import 'shared/utils/utils.dart';

class EditorStore {
  static String? get email => FirebaseAuth.instance.currentUser?.email;
  static String? get uid => FirebaseAuth.instance.currentUser?.uid;

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

  static bool isAdmin = false;
  static bool get isEditing => language != null;
  static SharedPreferences get prefs => GlobalStore.prefs;

  static Future _load(Iterable<String> languages) async {
    final saved = prefs.getString('editorLanguage');
    language = languages.contains(saved) ? saved : null;
    if (language == null) {
      isAdmin = false;
    } else {
      final token =
          await FirebaseAuth.instance.currentUser?.getIdTokenResult(true);
      isAdmin = language != null &&
          (json2list(token?.claims?['admin'])?.contains(language) ?? false);
    }
  }
}

class GlobalStore {
  static late final Algolia algolia;
  static late final SharedPreferences prefs;

  static Map<String, Language?> _languages = {};
  static Map<String, Language?> get languages => _languages;

  static Future<void> set(List<Language> languages) async {
    _languages = {
      for (final l in languages) l.name: l,
    };
    await EditorStore._load(_languages.keys);
    await prefs.setStringList(
      'languages',
      languages.map((l) => l.name).toList(),
    );
  }

  static Future<void> _load([List<String>? languages]) async {
    languages ??= prefs.getStringList('languages') ?? ['iron'];
    _languages = {for (final l in languages) l: null};

    for (final l in languages) {
      FirebaseFirestore.instance
          .doc('languages/$l')
          .withConverter(
            fromFirestore: (snapshot, _) => Language.fromJson(snapshot.data()!),
            toFirestore: (_, __) => {},
          )
          .get()
          .then((r) {
        final l = r.data();
        if (l != null) _languages[l.name] = l;
      });
    }

    EditorStore._load(_languages.keys);
    prefs.setStringList(
      'languages',
      languages.where((l) => _languages.containsKey(l)).toList(),
    );
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
    await _load();
  }
}
