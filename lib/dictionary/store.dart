import 'package:cloud_firestore/cloud_firestore.dart';

import '../utils.dart';
import 'concept/concept.dart';
import 'entry/entry.dart';
import 'models.dart';

final Map<String, List<Entry>> dictionaries = {};
final Map<String, Concept> concepts = {};
final List<SearchPreset> presets = [];
final List<String> grammarTags = [];
final List<String> semanticTags = [];

Future<void> load(Iterable<String> languages) async {
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
        dictionaries.clear();
        if (d.docs.isEmpty) return null;
        dictionaries[l] = d.docs.map((e) => e.data()).toList();
        return l;
      });
    }),
  );
  await FirebaseFirestore.instance
      .collection('meta/dictionary/concepts')
      .withConverter(
        fromFirestore: (snapshot, _) => Concept.fromJson(snapshot.data()!),
        toFirestore: (Concept object, _) => object.toJson(),
      )
      .get()
      .then((d) {
    concepts.clear();
    d.docs.forEach((d) => concepts[d.id] = d.data());
  });

  await FirebaseFirestore.instance.doc('meta/dictionary').get().then((d) {
    presets.clear();
    grammarTags.clear();
    semanticTags.clear();

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
