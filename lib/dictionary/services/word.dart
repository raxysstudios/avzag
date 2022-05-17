import 'package:avzag/global_store.dart';
import 'package:avzag/utils/contribution.dart';
import 'package:avzag/utils/snackbar_manager.dart';
import 'package:avzag/widgets/danger_dialog.dart';
import 'package:avzag/widgets/loading_dialog.dart';
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

Future<bool> submitWord(
  BuildContext context,
  Word word, [
  bool isReviewing = false,
]) async {
  if (!isReviewing && (word.uses.isEmpty || word.forms.isEmpty)) {
    showSnackbar(
      context,
      text: 'Must have at least a form and a use.',
    );
    return false;
  }
  final docId = isReviewing
      ? word.contribution?.overwriteId
      : EditorStore.isAdmin
          ? word.id
          : null;
  final entry = Word.fromJson(word.toJson(), word.id);
  entry.contribution = EditorStore.isAdmin
      ? null
      : Contribution(
          EditorStore.uid!,
          overwriteId: entry.id,
        );

  return await showLoadingDialog<bool>(
        context,
        FirebaseFirestore.instance
            .collection('dictionary')
            .doc(docId)
            .set(entry.toJson())
            .then((_) {
          if (isReviewing) {
            return FirebaseFirestore.instance
                .collection('dictionary')
                .doc(entry.id)
                .delete();
          }
        }).then((_) => true),
      ) ??
      false;
}

Future<bool> deleteWord(BuildContext context, String id) async {
  final confirm = await showDangerDialog(
    context,
    'Delete entry?',
    confirmText: 'Delete',
    rejectText: 'Keep',
  );
  if (confirm) {
    return await showLoadingDialog<bool>(
          context,
          FirebaseFirestore.instance
              .collection('dictionary')
              .doc(id)
              .delete()
              .then((_) => true),
        ) ??
        false;
  }
  return false;
}
