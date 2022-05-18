import 'package:avzag/modules/dictionary/widgets/samples_list.dart';
import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/caption.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/markdown_text.dart';
import 'package:avzag/shared/widgets/rounded_back_button.dart';
import 'package:avzag/shared/widgets/snackbar_manager.dart';

import 'package:flutter/material.dart';

import '../models/word.dart';

class WordScreen extends StatefulWidget {
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
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  @override
  Widget build(BuildContext context) {
    final word = widget.word;
    final theme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        leading: const RoundedBackButton(),
        title: Text(capitalize(word.language)),
        actions: [
          if (widget.onEdit != null)
            IconButton(
              onPressed: () {
                Navigator.pop(context);
                widget.onEdit!(word);
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
      body: ListView(
        controller: widget.scroll,
        padding: const EdgeInsets.only(bottom: 76),
        children: [
          ColumnCard(
            divider: const SizedBox(height: 8),
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                capitalize(word.headword),
                style: theme.headline6,
              ),
              if (word.ipa != null)
                Text(
                  word.ipa!,
                  style: theme.bodyText1?.copyWith(
                    color: theme.caption?.color,
                  ),
                ),
              if (word.tags != null)
                Text(
                  prettyTags(word.tags)!,
                  style: theme.caption,
                ),
              if (word.note != null) MarkdownText(word.note!),
            ],
          ),
          if (word.forms != null)
            SamplesList(
              word.forms!.skip(1),
              inline: true,
            ),
          for (final u in word.uses) ...[
            ColumnCard(
              divider: const SizedBox(height: 8),
              padding: const EdgeInsets.all(16),
              children: [
                Text(
                  capitalize(u.term),
                  style: theme.headline6?.copyWith(fontSize: 16),
                ),
                if (u.tags != null)
                  Text(
                    prettyTags(u.tags)!,
                    style: theme.caption,
                  ),
                if (u.note != null) MarkdownText(u.note!),
              ],
            ),
            if (u.samples != null) SamplesList(u.samples!),
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
