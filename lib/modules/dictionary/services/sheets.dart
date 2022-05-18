import 'package:avzag/modules/dictionary/screens/word_editor.dart';
import 'package:avzag/shared/widgets/modals/loading_dialog.dart';
import 'package:avzag/shared/widgets/modals/scrollable_modal_sheet.dart';
import 'package:avzag/shared/widgets/modals/snackbar_manager.dart';
import 'package:flutter/cupertino.dart';

import '../models/word.dart';
import '../screens/word.dart';
import 'word.dart';

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
        word,
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
