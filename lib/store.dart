import 'package:algolia/algolia.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading_dialog.dart';

class BaseStore {
  static late final Algolia algolia;
  static final List<String> languages = [];

  static Future<void> load(
    BuildContext context, {
    Iterable<String>? languages,
  }) async {
    return await showLoadingDialog(
      context: context,
      future: _loadStores(languages),
    );
  }

  static Future<void> _loadStores(
    Iterable<String>? languages,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    var saving = false;

    if (languages == null) {
      BaseStore.languages
        ..clear()
        ..addAll(prefs.getStringList('languages') ?? []);
      if (BaseStore.languages.isEmpty) BaseStore.languages.add('kaitag');
    } else
      saving = true;

    await Future.wait([
      HomeStore.load(BaseStore.languages),
      EditorStore.load(),
    ]);
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
  static Future<void> setLanguage(String? value) async {
    final prefs = await SharedPreferences.getInstance();
    if (!BaseStore.languages.contains(value)) value = null;
    if (value == null)
      await prefs.remove('editor');
    else
      await prefs.setString('editor', value);
    _language = value;
  }

  static Map<String, List<String>> editors = {};
  static String? get email => FirebaseAuth.instance.currentUser?.email;
  static List<String>? get editing => editors[email];

  static canEdit(String language) {
    return editing?.contains(language) ?? false;
  }

  static Future load() async {
    final prefs = await SharedPreferences.getInstance();
    setLanguage(prefs.getString('editor'));

    editors.clear();
    await FirebaseFirestore.instance.doc('meta/editors').get().then((d) {
      for (final u in d.data()!.entries) {
        editors[u.key] = json2list(u.value)!;
      }
    });
  }
}
