import 'package:algolia/algolia.dart';
import 'package:avzag/home/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BaseStore {
  static late final Algolia algolia;
  static List<String> _languages = [];
  static List<String> get languages => _languages;
  static set languages(List<String> value) {
    print('LNGS $value');
    value = value
        .where(
          (n) => HomeStore.languages.values.any(
            (l) => l.name == n,
          ),
        )
        .toList();
    _languages = value;
    print('LNGS $value');
    SharedPreferences.getInstance().then((prefs) {
      prefs.setStringList('languages', value);
    });
  }

  static Future<void> load(
    BuildContext context, {
    Iterable<String>? languages,
  }) async =>
      await _loadStores(languages);

  static Future<void> _loadStores(
    Iterable<String>? languages,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var saving = false;

    await Future.wait([
      HomeStore.load(),
      EditorStore.load(),
    ]);

    if (languages == null) {
      BaseStore.languages
        ..clear()
        ..addAll(prefs.getStringList('languages') ?? []);
      if (BaseStore.languages.isEmpty)
        BaseStore.languages.add(
          HomeStore.languages.values.first.name,
        );
    } else
      saving = true;

    if (saving)
      await prefs.setStringList(
        'languages',
        languages!.toList(),
      );
  }
}

class EditorStore {
  static String? _language;
  static String? get language => _language;
  static set language(String? value) {
    if (!BaseStore.languages.contains(value)) value = null;
    _language = value;
    SharedPreferences.getInstance().then((prefs) {
      if (value == null)
        prefs.remove('editor');
      else
        prefs.setString('editor', value);
    });
  }

  static String? get email => FirebaseAuth.instance.currentUser?.email;

  static Future load() async {
    final prefs = await SharedPreferences.getInstance();
    language = prefs.getString('editor');
  }
}
