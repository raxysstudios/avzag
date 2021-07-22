import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'models.dart';

class DictionaryStore {
  static final List<SearchPreset> presets = [];
  static final List<String> grammarTags = [];
  static final List<String> semanticTags = [];

  static bool _scholar = false;
  static bool get scholar => _scholar;
  static set scholar(bool value) {
    _scholar = value;
    SharedPreferences.getInstance().then(
      (prefs) => prefs.setBool('dictionary.scholar', value),
    );
  }

  static Future<void> load(List<String> langs) async {
    SharedPreferences.getInstance().then((prefs) {
      _scholar = prefs.getBool('dictionary.scholar') ?? false;
    });

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
