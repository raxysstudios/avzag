import 'package:avzag/modules/dictionary/screens/word_editor.dart';
import 'package:avzag/modules/dictionary/screens/words_diff.dart';
import 'package:avzag/shared/widgets/modals/loading_dialog.dart';
import 'package:avzag/shared/widgets/modals/scrollable_modal_sheet.dart';
import 'package:avzag/shared/widgets/modals/snackbar_manager.dart';
import 'package:flutter/cupertino.dart';

import '../models/word.dart';
import '../screens/word.dart';
import 'word.dart';

Future<void> diffWords(
  BuildContext context,
  String id, [
  ValueSetter<Word>? onEdit,
]) async {
  final overwrite = await showLoadingDialog(context, loadWord(id));
  if (overwrite?.contribution == null) return showSnackbar(context);
  final base = await showLoadingDialog(
    context,
    loadWord(overwrite?.contribution?.overwriteId),
  );
  await showScrollableModalSheet<void>(
    context: context,
    builder: (context, scroll) {
      return WordsDiffScreen(
        base,
        overwrite!,
        scroll: scroll,
      );
    },
  );
}

Future<void> openWord(
  BuildContext context,
  String id, [
  ValueSetter<Word>? onEdit,
]) async {
  final word = await showLoadingDialog(context, loadWord(id));
  if (word == null) return showSnackbar(context);
  await showScrollableModalSheet<void>(
    context: context,
    builder: (context, scroll) {
      return WordScreen(
        word: word,
        scroll: scroll,
        onEdit: onEdit,
      );
    },
  );
}

Future<void> editWord(
  BuildContext context,
  Word word, [
  VoidCallback? onDone,
]) async {
  await showScrollableModalSheet<void>(
    context: context,
    builder: (context, scroll) {
      return WordEditorScreen(
        word,
        scroll: scroll,
        onDone: onDone,
      );
    },
  );
}
