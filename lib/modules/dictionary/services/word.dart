import 'package:avzag/global_store.dart';
import 'package:avzag/shared/utils/contribution.dart';
import 'package:avzag/shared/widgets/modals/danger_dialog.dart';
import 'package:avzag/shared/widgets/modals/loading_dialog.dart';
import 'package:avzag/shared/widgets/modals/snackbar_manager.dart';
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
  final overwrite = word.contribution?.overwriteId;
  final id = overwrite ?? word.id;
  word.contribution = EditorStore.isAdmin
      ? null
      : Contribution(
          EditorStore.uid!,
          overwriteId: id,
        );

  await showLoadingDialog(
    context,
    FirebaseFirestore.instance
        .collection('dictionary')
        .doc(id)
        .set(word.toJson())
        .then((_) {
      if (overwrite != null) {
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
    'Delete entry?',
    confirmText: 'Delete',
    rejectText: 'Keep',
  );
}
