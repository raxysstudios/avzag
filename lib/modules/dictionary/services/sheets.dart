import 'package:avzag/shared/widgets/loading_dialog.dart';
import 'package:avzag/shared/widgets/scrollable_modal_sheet.dart';
import 'package:avzag/shared/widgets/snackbar_manager.dart';
import 'package:flutter/cupertino.dart';

import '../screens/word.dart';
import 'word.dart';

Future<void> openWord(BuildContext context, String id) async {
  final word = await showLoadingDialog(context, loadWord(id));
  if (word == null) return showSnackbar(context);
  await showScrollableModalSheet<void>(
    context: context,
    builder: (context, scroll) {
      return WordScreen(
        word,
        scroll: scroll,
      );
    },
  );
}
