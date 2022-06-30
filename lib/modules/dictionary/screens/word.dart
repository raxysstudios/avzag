import 'package:avzag/modules/navigation/services/router.gr.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/modals/snackbar_manager.dart';
import 'package:avzag/shared/widgets/language_flag.dart';
import 'package:avzag/shared/widgets/rounded_back_button.dart';
import 'package:flutter/material.dart';

import '../models/word.dart';
import '../widgets/word_view.dart';

class WordScreen extends StatelessWidget {
  const WordScreen(
    this.word, {
    this.scroll,
    this.onEdit,
    Key? key,
  }) : super(key: key);

  final Word word;
  final ScrollController? scroll;
  final ValueSetter<Word>? onEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const RoundedBackButton(
          route: DictionaryRoute(),
        ),
        title: Stack(
          alignment: Alignment.center,
          children: [
            Text(word.language.titled),
          ],
        ),
        actions: [
          Opacity(
            opacity: .5,
            child: LanguageFlag(
              word.language,
              width: 160,
              offset: const Offset(16, -2),
              scale: 1.25,
            ),
          ),
          if (onEdit != null)
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                onEdit!(word);
              },
              tooltip: 'Edit',
              icon: const Icon(Icons.edit_rounded),
            ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showSnackbar(
          context,
          text: 'Word sharing is coming soon',
        ),
        tooltip: 'Share',
        child: const Icon(Icons.share_rounded),
      ),
      body: WordView(word, scroll: scroll),
    );
  }
}
