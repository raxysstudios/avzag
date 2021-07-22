import 'package:cloud_firestore/cloud_firestore.dart';
import 'concept/concept.dart';
import 'entry/entry.dart';
import 'models.dart';

class DictionaryStore {
  static final Map<String, List<Entry>> dictionaries = {};
  static final Map<String, Concept> concepts = {};
  static final List<SearchPreset> presets = [];
  static final List<String> grammarTags = [];
  static final List<String> semanticTags = [];

  static Future<void> load(List<String> langs) async {
    final docs =
        await FirebaseFirestore.instance.collectionGroup('dictionary').get();
    // final docs = await FirebaseFirestore.instance
    //     .collection('languages/kaitag/dictionary')
    //     .where('forms', isEqualTo: 'бизи')
    //     .get();
    print('### QUERY ${docs.docs.length}');

    // dictionaries.clear();
    // await Future.wait(
    //   langs.map((l) {
    //     return FirebaseFirestore.instance
    //         .collection('languages/$l/dictionary')
    //         .withConverter(
    //           fromFirestore: (snapshot, _) => Entry.fromJson(
    //             snapshot.data()!,
    //             id: snapshot.id,
    //           ),
    //           toFirestore: (Entry object, _) => object.toJson(),
    //         )
    //         .get()
    //         .then((d) {
    //       if (d.docs.isEmpty) return null;
    //       dictionaries[l] = d.docs.map((e) => e.data()).toList();
    //     });
    //   }),
    // );
    // concepts.clear();
    // await FirebaseFirestore.instance
    //     .collection('meta/dictionary/concepts')
    //     .withConverter(
    //       fromFirestore: (snapshot, _) => Concept.fromJson(snapshot.data()!),
    //       toFirestore: (Concept object, _) => object.toJson(),
    //     )
    //     .get()
    //     .then((d) {
    //   d.docs.forEach((d) => concepts[d.id] = d.data());
    // });

    // presets.clear();
    // grammarTags.clear();
    // semanticTags.clear();
    // await FirebaseFirestore.instance.doc('meta/dictionary').get().then((d) {
    //   final data = d.data()!;
    //   presets.addAll(
    //     listFromJson(
    //       data['presets'],
    //       (i) => SearchPreset.fromJson(i),
    //     )!,
    //   );
    //   grammarTags.addAll(
    //     json2list(data['tags']['grammar'])!,
    //   );
    //   semanticTags.addAll(
    //     json2list(data['tags']['semantic'])!,
    //   );
    // });
  }
}
