import 'dart:typed_data';
import 'package:avzag/home/language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomeStore {
  static final Map<String, Language> languages = {};
  static final Map<String, Uint8List> flags = {};

  static Future<void> load(List<String> langs) async {
    languages.clear();
    flags.clear();
    await FirebaseFirestore.instance
        .collection('languages')
        .orderBy('family')
        .orderBy('name')
        .withConverter(
          fromFirestore: (snapshot, _) => Language.fromJson(snapshot.data()!),
          toFirestore: (Language language, _) => language.toJson(),
        )
        .get()
        .then((d) async {
      for (final d in d.docs) {
        final l = d.data();
        if (flags[l.flag] == null) {
          final flag = await FirebaseStorage.instance
              .ref('flags/${l.flag}.png')
              .getData();
          if (flag != null) flags[l.flag] = flag;
        }
        languages[d.id] = l;
      }
    });
  }
}
