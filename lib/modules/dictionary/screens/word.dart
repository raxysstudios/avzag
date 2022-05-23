import 'package:avzag/modules/dictionary/widgets/samples_column.dart';
import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/caption.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/language_flag.dart';
import 'package:avzag/shared/widgets/markdown_text.dart';
import 'package:avzag/shared/widgets/modals/snackbar_manager.dart';
import 'package:avzag/shared/widgets/rounded_back_button.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/word.dart';

class WordScreen extends StatelessWidget {
  const WordScreen(
    this.word, {
    this.scroll,
    this.onEdit,
    this.embedded = false,
    Key? key,
  }) : super(key: key);

  final Word word;
  final bool embedded;
  final ScrollController? scroll;
  final ValueSetter<Word>? onEdit;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: embedded
          ? null
          : AppBar(
              leading: const RoundedBackButton(),
              title: Stack(
                alignment: Alignment.center,
                children: [
                  Text(capitalize(word.language)),
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
      floatingActionButton: embedded
          ? null
          : FloatingActionButton(
              onPressed: () => showSnackbar(
                context,
                text: 'Word sharing is coming soon',
              ),
              tooltip: 'Share',
              child: const Icon(Icons.share_rounded),
            ),
      body: ListView(
        controller: scroll,
        padding: const EdgeInsets.only(bottom: 76),
        children: [
          ColumnCard(
            divider: const SizedBox(height: 4),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 8,
            ),
            children: [
              Text(
                capitalize(word.headword),
                style: GoogleFonts.bitter(
                  textStyle: theme.headline5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (word.ipa != null)
                Text(
                  '[ ${word.ipa!} ]',
                  style: GoogleFonts.notoSans(
                    textStyle: theme.bodyText1,
                    color: theme.caption?.color,
                  ),
                ),
              if (word.tags.isNotEmpty)
                Text(
                  prettyTags(word.tags)!,
                  style: theme.caption,
                ),
              if (word.note != null) MarkdownText(word.note!),
            ],
          ),
          if (word.forms.isNotEmpty)
            SamplesColumn(
              word.forms,
              inline: true,
            ),
          for (final u in word.uses) ...[
            ColumnCard(
              divider: const SizedBox(height: 4),
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 8,
              ),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        capitalize(u.term),
                        style: theme.headline6,
                      ),
                    ),
                    if (u.aliases.isNotEmpty)
                      Tooltip(
                        message: prettyTags(u.aliases)!,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 8),
                          child: Icon(
                            Icons.label_rounded,
                            color: Theme.of(context).textTheme.caption?.color,
                          ),
                        ),
                      )
                  ],
                ),
                if (u.tags.isNotEmpty)
                  Text(
                    prettyTags(u.tags)!,
                    style: theme.caption,
                  ),
                if (u.note != null) MarkdownText(u.note!),
              ],
            ),
            if (u.examples.isNotEmpty) SamplesColumn(u.examples),
          ],
          if (word.contribution != null)
            const Caption(
              'Unverified',
              icon: Icons.unpublished_rounded,
            ),
        ],
      ),
    );
  }
}
