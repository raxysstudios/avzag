import 'package:avzag/models/contribution.dart';
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

void acceptContribution(
  BuildContext context,
  Word word, {
  VoidCallback? after,
}) async {
  var id = word.contribution?.overwriteId;
  var doc = word.toJson();
  doc.remove('contribution');
  await showLoadingDialog(
    context,
    FirebaseFirestore.instance.collection('dictionary').doc(id).set(doc).then(
          (_) => FirebaseFirestore.instance
              .collection('dictionary')
              .doc(word.id)
              .delete(),
        ),
  ).then((_) => after?.call());
}

void submitWord(
  BuildContext context,
  Word word, {
  VoidCallback? after,
}) async {
  if (word.uses.isEmpty) {
    return showSnackbar(
      context,
      text: 'Must have at least one use',
    );
  }
  var id = word.id;
  var doc = word.toJson();
  if (!EditorStore.admin) {
    doc['contribution'] = Contribution(
      EditorStore.user?.uid ?? 'anon',
      overwriteId: word.id,
    ).toJson();
    id = null;
  }

  await showLoadingDialog(
    context,
    FirebaseFirestore.instance.collection('dictionary').doc(id).set(doc),
  ).then((_) => after?.call());
}

void deleteWord(
  BuildContext context,
  String id, {
  VoidCallback? after,
  String title = 'Delete the word?',
}) {
  showDangerDialog(
    context,
    () => showLoadingDialog(
      context,
      FirebaseFirestore.instance.collection('dictionary').doc(id).delete(),
    ).then((_) => after?.call()),
    title,
    confirmText: 'Delete',
    rejectText: 'Keep',
  );
}
