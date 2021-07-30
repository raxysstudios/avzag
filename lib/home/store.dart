import 'package:avzag/home/language.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomeStore {
  static final Map<String, Language> languages = {};

  static Future<void> load() async {
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
      for (final d in d.docs) languages[d.id] = d.data();
    });
  }
}
