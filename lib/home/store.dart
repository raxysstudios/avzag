import 'package:avzag/home/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'language_flag.dart';

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
        languages[d.id] = l;
        await donwloadFlag(l);
      }
    });
  }
}
