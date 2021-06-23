import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'phoneme/phoneme.dart';

class PhonologyStore {
  static final Map<String, Map<String, Phoneme>> phonemes = {};

  static Future<void> load(List<String> langs) async {
    phonemes.clear();
    await Future.wait(
      langs.map((l) {
        return FirebaseFirestore.instance
            .collection('languages/$l/phonology')
            .withConverter(
              fromFirestore: (snapshot, _) => Phoneme.fromJson(
                snapshot.data()!,
              ),
              toFirestore: (Phoneme object, _) => object.toJson(),
            )
            .get()
            .then((d) {
          if (d.docs.isEmpty) return null;
          for (final d in d.docs) {
            final phoneme = d.data();
            phoneme.samples?.forEach((s) async {
              s.audioUrl = await FirebaseStorage.instance
                  .ref('$l/phonology/${s.word}.m4a')
                  .getDownloadURL();
            });
            final ipa = phoneme.ipa;
            if (phonemes[ipa] == null) phonemes[ipa] = {};
            phonemes[ipa]![l] = phoneme;
          }
        });
      }),
    );
  }
}
