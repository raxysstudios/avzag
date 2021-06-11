import 'package:avzag/home/language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class HomeStore {
  static final Map<String, Language> languages = {};

  static Future<void> load(List<String> langs) async {
    languages.clear();
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
        l.flagUrl = await FirebaseStorage.instance
            .ref('flags/${l.flag}.png')
            .getDownloadURL();
        languages[d.id] = l;
      }
    });
  }
}
