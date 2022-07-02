import 'package:auto_route/auto_route.dart';
import 'package:avzag/modules/dictionary/models/word.dart';
import 'package:avzag/modules/dictionary/screens/word.dart';
import 'package:avzag/modules/dictionary/services/word.dart';
import 'package:avzag/modules/navigation/screens/loader.dart';
import 'package:avzag/modules/navigation/services/router.gr.dart';
import 'package:avzag/shared/modals/scrollable_modal_sheet.dart';
import 'package:flutter/material.dart';

class WordLoaderScreen extends StatelessWidget {
  const WordLoaderScreen(
    @pathParam this.id, {
    this.onEdit,
    Key? key,
  }) : super(key: key);

  final String id;
  final void Function(Word)? onEdit;

  @override
  Widget build(BuildContext context) {
    return LoaderScreen<Word>(
      loadWord(id),
      then: (context, w) async {
        if (w != null) {
          await showScrollableModalSheet<void>(
            context,
            (context, scroll) {
              return WordScreen(
                w,
                scroll: scroll,
                onEdit: onEdit,
              );
            },
          );
        }
        return const DictionaryRoute();
      },
    );
  }
}
