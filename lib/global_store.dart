import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/language.dart';

class GlobalStore {
  static late final Algolia algolia;
  static late final SharedPreferences prefs;

  static Map<String, Language> _languages = {};
  static Map<String, Language> get languages => _languages;

  static String? _editing;
  static String? get editing => _editing;
  static set editing(String? value) {
    _editing = value;
    if (value == null)
      prefs.remove('editor');
    else
      prefs.setString('editor', value);
  }

  static String? get email => FirebaseAuth.instance.currentUser?.email;

  static Future<void> load(
    BuildContext context, {
    List<String>? languages,
  }) async {
    prefs = await SharedPreferences.getInstance();
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

    _editing = prefs.getString('editor');
    if (_editing != null && !_languages.containsKey(_editing)) editing = null;

    await prefs.setStringList(
      'languages',
      languages.where((l) => _languages.containsKey(l)).toList(),
    );

    print('CTL $_languages');
  }
}
