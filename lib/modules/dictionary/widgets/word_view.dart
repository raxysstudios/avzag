import 'package:avzag/modules/dictionary/models/word.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/widgets/caption.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/markdown_text.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'samples_column.dart';

class WordView extends StatelessWidget {
  const WordView(
    this.word, {
    this.scroll,
    Key? key,
  }) : super(key: key);

  final Word word;
  final ScrollController? scroll;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return ListView(
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
              word.headword.titled,
              style: GoogleFonts.bitter(
                textStyle: theme.headline5,
                fontWeight: FontWeight.w600,
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
                word.tags.join(', '),
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
                      u.term.titled,
                      style: theme.headline6,
                    ),
                  ),
                  if (u.aliases.isNotEmpty)
                    Tooltip(
                      message: u.aliases.join(' • ').titled,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8),
                        child: Icon(
                          Icons.label_outlined,
                          color: Theme.of(context).textTheme.caption?.color,
                        ),
                      ),
                    )
                ],
              ),
              if (u.tags.isNotEmpty)
                Text(
                  u.tags.join(', '),
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
            icon: Icons.unpublished_outlined,
          ),
      ],
    );
  }
}
