import 'package:avzag/dictionary/store.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/phonology/store.dart';
import 'package:avzag/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading_dialog.dart';

class BaseStore {
  static final List<String> languages = [];

  static Future<void> load(BuildContext context) async {
    FirebaseFirestore.instance.settings = Settings(
      cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
    );
    FirebaseStorage.instance.setMaxOperationRetryTime(
      Duration(milliseconds: 100),
    );
    return await showLoadingDialog(
      context: context,
      future: _loadStores(),
    );
  }

  static Future<void> _loadStores() async {
    final prefs = await SharedPreferences.getInstance();
    languages
      ..clear()
      ..addAll(prefs.getStringList('languages') ?? []);
    if (languages.isEmpty) languages.add('kaitag');

    await Future.wait([
      HomeStore.load(languages),
      EditorStore.load(),
      PhonologyStore.load(languages),
      DictionaryStore.load(languages),
    ]);
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
