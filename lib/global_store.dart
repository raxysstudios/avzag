import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/language.dart';

class EditorStore {
  static String? get email => FirebaseAuth.instance.currentUser?.email;
  static bool isAdmin = false;
  static bool get isEditing => language != null;

  static String? _language;
  static String? get language => _language;
  static set language(String? value) {
    _language = value;
    if (value == null) {
      GlobalStore.prefs.remove('editorLanguage');
    } else {
      GlobalStore.prefs.setString('editorLanguage', value);
    }
  }
}

class GlobalStore {
  static bool _first = true;
  static late final Algolia algolia;
  static late final SharedPreferences prefs;

  static Map<String, Language> _languages = {};
  static Map<String, Language> get languages => _languages;

  static String? get email => FirebaseAuth.instance.currentUser?.email;

  static Future<void> load([List<String>? languages]) async {
    if (_first) await _init();
    languages ??= prefs.getStringList('languages') ?? ['iron'];

    await Future.wait<Language?>(
      languages.map(
        (l) => FirebaseFirestore.instance
            .doc('languages/$l')
            .withConverter(
              fromFirestore: (snapshot, _) =>
                  Language.fromJson(snapshot.data()!),
              toFirestore: (Language language, _) => language.toJson(),
            )
            .get()
            .then((r) => r.data()),
      ),
    ).then(
      (c) {
        _languages = {
          for (final l in c.where((l) => l != null)) l!.name: l,
        };
      },
    );

    await prefs.setStringList(
      'languages',
      languages.where((l) => _languages.containsKey(l)).toList(),
    );
  }

  static Future<void> _init() async {
    _first = false;
    await Firebase.initializeApp();
    prefs = await SharedPreferences.getInstance();
    algolia = const Algolia.init(
      applicationId: 'NYVVAA43NI',
      apiKey: 'cf52a68ac340fc555978892202ce37df',
    );
  }
}
