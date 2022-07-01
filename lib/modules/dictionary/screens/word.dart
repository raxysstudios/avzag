import 'package:avzag/modules/dictionary/services/sharing.dart';
import 'package:avzag/modules/navigation/services/router.gr.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/utils.dart';
import 'package:avzag/shared/widgets/language_flag.dart';
import 'package:avzag/shared/widgets/options_button.dart';
import 'package:avzag/shared/widgets/rounded_back_button.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

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
          OptionsButton(
            [
              OptionItem.simple(
                Icons.link_rounded,
                'Share link',
                onTap: () => Share.share(previewArticle(word)),
              ),
              OptionItem.tile(
                const Icon(Icons.article_rounded),
                const Text('Share text'),
                onTap: () => Share.share(
                  textifyArticle(word),
                ),
              ),
              OptionItem.divider(),
              OptionItem.tile(
                const Icon(Icons.code_rounded),
                const Text('Copy HTML'),
                onTap: () => copyText(
                  context,
                  textifyArticle(word, true),
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
              onPressed: () {
                Navigator.pop(context);
                onEdit!(word);
              },
            ),
      body: WordView(word, scroll: scroll),
    );
  }
}
