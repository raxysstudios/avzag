import 'package:avzag/global_store.dart';
import 'package:avzag/shared/widgets/scrollable_modal_sheet.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:flutter/cupertino.dart';

import '../models/entry.dart';
import '../models/word.dart';
import '../screens/word.dart';
import 'word.dart';

Future<void> openEntry({
  required BuildContext context,
  required ValueSetter<Word?> onEdit,
  Word? entry,
  Entry? hit,
  Word? elseEntry,
}) async {
  Word? sourceEntry;
  await showLoadingDialog(
    context,
    (() async {
      if (entry == null && hit != null) entry = await loadWord(hit.entryID);
      if (EditorStore.isAdmin) {
        sourceEntry = await loadWord(entry?.contribution?.overwriteId);
      }
    })(),
  );
  entry ??= elseEntry;
  if (entry == null) return;
  await showScrollableModalSheet<void>(
    context: context,
    builder: (context, scroll) {
      return WordScreen(
        entry!,
        editing: hit == null,
        sourceEntry: sourceEntry,
        onEdited: onEdit,
        scroll: scroll,
      );
    },
  );
}
