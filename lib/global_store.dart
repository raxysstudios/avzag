import 'package:algolia/algolia.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home/language.dart';

class GlobalStore {
  static late final Algolia algolia;

  static Map<String, Language> _catalogue = {};
  static Map<String, Language> get catalogue => _catalogue;

  static List<String> _languages = [];
  static List<String> get languages => _languages;

  static String? _editing;
  static String? get editing => _editing;
  static set editing(String? value) {
    _editing = value;
    SharedPreferences.getInstance().then((prefs) {
      if (value == null)
        prefs.remove('editor');
      else
        prefs.setString('editor', value);
    });
  }

  static String? get email => FirebaseAuth.instance.currentUser?.email;

  static Future<void> load(
    BuildContext context, {
    List<String>? languages,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    if (languages == null) {
      languages = prefs.getStringList('languages') ?? [catalogue.keys.first];
      languages = languages.where((l) => catalogue.containsKey(l)).toList();
    } else
      await prefs.setStringList(
        'languages',
        languages.toList(),
      );

    _languages = languages;
    _catalogue = await Future.wait<Language?>(
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
      (l) => Map.fromIterable(
        l.where((l) => l != null),
        key: (d) => d.id,
        value: (d) => d.data(),
      ),
    );
    _editing = prefs.getString('editor');
  }
}
