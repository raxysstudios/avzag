import 'package:avzag/dictionary/store.dart';
import 'package:avzag/home/models.dart';
import 'package:avzag/home/store.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

String? editorMode;
List<Language> loadedLanguages = [];

Future<void> loadAll(BuildContext? context) async {
  var loader = SharedPreferences.getInstance()
      .then((prefs) => prefs.getStringList('languages'))
      .then((langs) async {
    if (langs == null || langs.isEmpty) langs = ['kaitag'];
    await Future.wait([
      loadHome(langs),
      loadDictionary(langs),
    ]);
    return langs;
  }).then((langs) {
    loadedLanguages = langs
        .map(
          (n) => languages.firstWhere((l) => l.name == n),
        )
        .toList();
  });
  if (context == null) return await loader;
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      loader.then((_) => Navigator.pop(context));
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
