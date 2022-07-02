import 'package:auto_route/auto_route.dart';
import 'package:avzag/modules/dictionary/services/sharing.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/utils.dart';
import 'package:avzag/shared/widgets/language_flag.dart';
import 'package:avzag/shared/widgets/options_button.dart';
import 'package:avzag/shared/widgets/rounded_back_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import '../models/word.dart';
import '../widgets/word_view.dart';

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
        leading: const RoundedBackButton(),
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
          OptionsButton(
            [
              OptionItem.simple(
                Icons.link_rounded,
                'Share link',
                onTap: () => copyText(
                  context,
                  previewArticle(word),
                ),
              ),
              OptionItem.tile(
                const Icon(Icons.article_rounded),
                const Text('Share article'),
                onTap: () => copyText(
                  context,
                  textifyArticle(word),
                ),
              ),
            ],
            icon: const Icon(Icons.share_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: onEdit == null
          ? null
          : FloatingActionButton(
              child: const Icon(Icons.edit_rounded),
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
