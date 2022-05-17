import 'package:avzag/global_store.dart';
import 'package:avzag/shared/utils/contribution.dart';
import 'package:avzag/shared/widgets/danger_dialog.dart';
import 'package:avzag/shared/widgets/loading_dialog.dart';
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

Future<bool> submitWord(BuildContext context, Word word) async {
  final overwrite = word.contribution?.overwriteId;
  final id = overwrite ?? word.id;
  word.contribution = EditorStore.isAdmin
      ? null
      : Contribution(
          EditorStore.uid!,
          overwriteId: id,
        );

  return await showLoadingDialog<bool>(
        context,
        FirebaseFirestore.instance
            .collection('dictionary')
            .doc(id)
            .set(word.toJson())
            .then((_) {
          if (overwrite != null) {
            return FirebaseFirestore.instance
                .collection('dictionary')
                .doc(word.id)
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
