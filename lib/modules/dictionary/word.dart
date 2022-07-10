import 'package:auto_route/auto_route.dart';
import 'package:bazur/models/word.dart';
import 'package:bazur/modules/dictionary/services/sharing.dart';
import 'package:bazur/shared/utils.dart';
import 'package:bazur/shared/widgets/language_title.dart';
import 'package:bazur/shared/widgets/options_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'widgets/word_view.dart';

class WordScreen extends StatelessWidget {
  const WordScreen(
    this.word, {
    @pathParam String? id,
    this.onEdit,
    Key? key,
  }) : super(key: key);

  final Word word;
  final ValueSetter<Word>? onEdit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: LanguageTitle(word.language),
        actions: [
          OptionsButton(
            [
              OptionItem.simple(
                Icons.link_outlined,
                'Share link',
                onTap: () => copyText(
                  context,
                  previewArticle(word),
                ),
              ),
              OptionItem.tile(
                const Icon(Icons.article_outlined),
                const Text('Share article'),
                onTap: () => copyText(
                  context,
                  textifyArticle(word),
                ),
              ),
            ],
            icon: const Icon(Icons.share_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: onEdit == null
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.edit_outlined),
              onPressed: () async {
                context.popRoute();
                onEdit!(word);
              },
            ),
      body: WordView(
        word,
        scroll: ModalScrollController.of(context),
      ),
    );
  }
}
