import 'package:avzag/dictionary/store.dart';
import 'package:avzag/home/store.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'loading_dialog.dart';

class BaseStore {
  static late SharedPreferences _prefs;

  static String? _editorMode;
  static String? get editorMode => _editorMode;
  static Future<void> setEditorMode(String? value) async {
    if (!languages.contains(value)) value = null;
    if (value == null)
      await _prefs.remove('editor');
    else
      await _prefs.setString('editor', value);
    _editorMode = value;
  }

  static final List<String> languages = [];

  static Future<void> load(BuildContext context) async {
    return await showLoadingDialog(
      context: context,
      future: _loadStores(),
    );
  }

  static Future<void> _loadStores() async {
    _prefs = await SharedPreferences.getInstance();

    languages
      ..clear()
      ..addAll(_prefs.getStringList('languages') ?? []);
    if (languages.isEmpty) languages.add('kaitag');

    setEditorMode(_prefs.getString('editor'));

    await Future.wait([
      HomeStore.load(languages),
      DictionaryStore.load(languages),
    ]);
  }
}
