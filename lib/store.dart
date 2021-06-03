import 'package:avzag/dictionary/store.dart';
import 'package:avzag/home/store.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    return await showLoadingBlock(context, loadStores());
  }

  static Future<void> loadStores() async {
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

  static Future<void> showLoadingBlock(
    BuildContext context,
    Future future,
  ) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        future.then((_) => Navigator.pop(context));
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(0),
            content: Container(
              height: 128,
              width: 128,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Downloading, please wait...'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
