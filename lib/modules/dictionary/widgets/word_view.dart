import 'package:bazur/models/word.dart';
import 'package:bazur/shared/extensions.dart';
import 'package:bazur/shared/utils.dart';
import 'package:bazur/shared/widgets/caption.dart';
import 'package:bazur/shared/widgets/column_card.dart';
import 'package:bazur/shared/widgets/markdown_text.dart';
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
            SelectableText(
              word.headword.titled,
              style: styleNative.copyWith(
                fontSize: theme.headline5?.fontSize,
              ),
            ),
            if (word.ipa != null)
              SelectableText(
                '[${word.ipa!}]',
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
        for (final d in word.definitions) ...[
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
                  Text(
                    '${word.definitions.indexOf(d) + 1}',
                    style: theme.headline6?.copyWith(
                      color: theme.caption?.color,
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: SelectableText(
                        d.translation.titled,
                        style: theme.headline6,
                      ),
                    ),
                  ),
                  if (d.aliases.isNotEmpty)
                    Tooltip(
                      waitDuration: Duration.zero,
                      triggerMode: TooltipTriggerMode.tap,
                      message: d.aliases.join(' • ').titled,
                      child: Icon(
                        Icons.label_outlined,
                        color: Theme.of(context).textTheme.caption?.color,
                      ),
                    )
                ],
              ),
              if (d.tags.isNotEmpty)
                Text(
                  d.tags.join(', '),
                  style: theme.caption,
                ),
              if (d.note != null) MarkdownText(d.note!),
            ],
          ),
          if (d.examples.isNotEmpty) SamplesColumn(d.examples),
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
