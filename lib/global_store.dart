import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/language.dart';
import 'utils/utils.dart';

class EditorStore {
  static String? get email => FirebaseAuth.instance.currentUser?.email;
  static String? get uid => FirebaseAuth.instance.currentUser?.uid;

  static bool isAdmin = false;
  static bool get isEditing => language != null;

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

  static get prefs => GlobalStore.prefs;

  static Future _load() async {
    EditorStore._language = prefs.getString('editorLanguage');
    final token =
        await FirebaseAuth.instance.currentUser?.getIdTokenResult(true);
    EditorStore.isAdmin =
        json2list(token?.claims?['admin'])?.contains(EditorStore._language) ??
            false;
  }
}

class GlobalStore {
  static bool _first = true;
  static late final Algolia algolia;
  static late final SharedPreferences prefs;

  static Map<String, Language> _languages = {};
  static Map<String, Language> get languages => _languages;

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

    await EditorStore._load();
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
