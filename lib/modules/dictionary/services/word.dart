import 'package:avzag/shared/utils/contribution.dart';
import 'package:avzag/shared/widgets/modals/danger_dialog.dart';
import 'package:avzag/shared/widgets/modals/loading_dialog.dart';
import 'package:avzag/shared/widgets/modals/snackbar_manager.dart';
import 'package:avzag/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/word.dart';

Future<Word?> loadWord(String? id) async {
  if (id == null) return null;
  final doc = await FirebaseFirestore.instance
      .collection('dictionary')
      .doc(id)
      .withConverter(
        fromFirestore: (snapshot, _) => Word.fromJson(
          snapshot.data()!,
          snapshot.id,
        ),
        toFirestore: (Word object, _) => object.toJson(),
      )
      .get();
  return doc.data();
}

void submitWord(
  BuildContext context,
  Word word, [
  VoidCallback? after,
]) async {
  if (word.uses.isEmpty) {
    return showSnackbar(
      context,
      text: 'Must have at least one use',
    );
  }
  var id = word.id;
  var doc = word.toJson();
  var cleanup = false;
  if (EditorStore.admin) {
    if (word.contribution != null) {
      cleanup = true;
      id = word.contribution?.overwriteId;
      doc.remove('contribution');
    }
  } else {
    doc['contribution'] = Contribution(
      EditorStore.user?.uid ?? 'anon',
      overwriteId: id,
    ).toJson();
  }

  await showLoadingDialog(
    context,
    FirebaseFirestore.instance
        .collection('dictionary')
        .doc(id)
        .set(doc)
        .then((_) {
      if (cleanup) {
        FirebaseFirestore.instance
            .collection('dictionary')
            .doc(word.id)
            .delete();
      }
    }),
  ).then((_) => after?.call());
}

void deleteWord(
  BuildContext context,
  String id, [
  VoidCallback? after,
]) {
  showDangerDialog(
    context,
    () => showLoadingDialog(
      context,
      FirebaseFirestore.instance.collection('dictionary').doc(id).delete(),
    ).then((_) => after?.call()),
    'Delete the word?',
    confirmText: 'Delete',
    rejectText: 'Keep',
  );
}
