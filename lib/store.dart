import 'package:avzag/dictionary/store.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading_dialog.dart';

class BaseStore {
  static final List<String> languages = [];

  static Future<void> load(BuildContext context) async {
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

  static final Map<String, Iterable<String>> _admins = {};
  static Map<String, Iterable<String>> get admins => _admins;
  static String? get email => FirebaseAuth.instance.currentUser?.email;
  static bool get isAdmin => _admins[email]?.contains(language) ?? false;

  static Future load() async {
    final prefs = await SharedPreferences.getInstance();
    setLanguage(prefs.getString('editor'));

    _admins.clear();
    await FirebaseFirestore.instance
        .doc('meta/users')
        .get()
        .then((d) => d.data()!['admins'] as Map<String, dynamic>)
        .then((data) {
      for (final d in data.entries) _admins[d.key] = json2list(d.value)!;
    });
  }
}
