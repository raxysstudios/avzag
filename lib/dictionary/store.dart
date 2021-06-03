import 'package:avzag/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'concept/concept.dart';
import 'entry/entry.dart';
import 'models.dart';

final Map<String, List<Entry>> dictionaries = {};
final Map<String, Concept> concepts = {};
final List<SearchPreset> presets = [];
final List<String> grammarTags = [];
final List<String> semanticTags = [];

Future<void> loadDictionary(Iterable<String> languages) async {
  dictionaries.clear();
  await Future.wait(
    languages.map((l) {
      return FirebaseFirestore.instance
          .collection('languages/$l/dictionary')
          .withConverter(
            fromFirestore: (snapshot, _) => Entry.fromJson(snapshot.data()!),
            toFirestore: (Entry object, _) => object.toJson(),
          )
          .get()
          .then((d) {
        if (d.docs.isEmpty) return null;
        dictionaries[l] = d.docs.map((e) => e.data()).toList();
      });
    }),
  );
  concepts.clear();
  await FirebaseFirestore.instance
      .collection('meta/dictionary/concepts')
      .withConverter(
        fromFirestore: (snapshot, _) => Concept.fromJson(snapshot.data()!),
        toFirestore: (Concept object, _) => object.toJson(),
      )
      .get()
      .then((d) {
    d.docs.forEach((d) => concepts[d.id] = d.data());
  });

  presets.clear();
  grammarTags.clear();
  semanticTags.clear();
  await FirebaseFirestore.instance.doc('meta/dictionary').get().then((d) {
    final data = d.data()!;
    presets.addAll(
      listFromJson(
        data['presets'],
        (i) => SearchPreset.fromJson(i),
      )!,
    );
    grammarTags.addAll(
      json2list(data['tags']['grammar'])!,
    );
    semanticTags.addAll(
      json2list(data['tags']['semantic'])!,
    );
  });
}
