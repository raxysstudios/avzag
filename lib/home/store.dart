import 'package:avzag/home/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'language_flag.dart';

List<Language> languages = [];

Future<void> loadHome(List<String> langs) async {
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
    languages = d.docs.map((l) => l.data()).toList();
    for (final l in languages) await donwloadFlag(l);
  });
}
