import 'package:auto_route/auto_route.dart';
import 'package:avzag/modules/dictionary/screens/word_editor.dart';
import 'package:avzag/modules/dictionary/screens/words_diff.dart';
import 'package:avzag/shared/modals/loading_dialog.dart';
import 'package:avzag/shared/modals/scrollable_modal_sheet.dart';
import 'package:avzag/shared/modals/snackbar_manager.dart';
import 'package:flutter/cupertino.dart';

import '../models/word.dart';
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
  // context.pushRoute(WordsDiffScreen(base, overwrite!));
  // context
  // await showScrollableModalSheet<void>(
  //   context,
  //   (context, scroll) {
  //     return WordsDiffScreen(
  //       base,
  //       overwrite!,
  //     );
  //   },
  // );
}

Future<void> editWord(
  BuildContext context,
  Word word, [
  VoidCallback? onDone,
]) async {
  // await showScrollableModalSheet<void>(
  //   context,
  //   (context, scroll) {
  //     return WordEditorScreen(
  //       word,
  //       onDone: onDone,
  //     );
  //   },
  // );
}
