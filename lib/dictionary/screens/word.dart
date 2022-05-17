import 'package:avzag/dictionary/widgets/meaning_tile.dart';
import 'package:avzag/dictionary/widgets/sample_tile.dart';
import 'package:avzag/dictionary/widgets/segment.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/markdown_text.dart';
import 'package:avzag/utils/editor_utils.dart';
import 'package:avzag/utils/utils.dart';
import 'package:avzag/widgets/note_tile.dart';
import 'package:avzag/widgets/rounded_back_button.dart';
import 'package:avzag/widgets/tags_tile.dart';
import 'package:avzag/widgets/text_sample_tiles.dart';
import 'package:flutter/material.dart';

import '../models/word.dart';

class WordScreen extends StatefulWidget {
  const WordScreen(
    this.word, {
    this.scroll,
    Key? key,
  }) : super(key: key);

  final Word word;
  final ScrollController? scroll;

  @override
  State<WordScreen> createState() => _WordScreenState();
}

class _WordScreenState extends State<WordScreen> {
  List<Widget> buildEntry(
    BuildContext context,
    Word entry, [
    EditorCallback? editor,
  ]) {
    return [
      Column(
        children: [
          TextSampleTiles(
            samples: entry.forms,
            onEdited: editor?.call(
              (v) => entry.forms = v ?? [],
            ),
            icon: Icons.layers_rounded,
            name: 'form',
          ),
          TagsTile(
            entry.tags,
            onEdited: editor?.call(
              (v) => entry.tags = v,
            ),
          ),
          NoteTile(
            entry.note,
            onEdited: editor?.call(
              (v) => entry.note = v,
            ),
          ),
        ],
      ),
      for (final use in entry.uses)
        Card(
          child: Column(
            children: [
              MeaningTile(
                use,
                onEdited: editor?.call((v) {
                  if (v == null) {
                    entry.uses.remove(use);
                  } else {
                    entry.uses[entry.uses.indexOf(use)] = v;
                  }
                }),
              ),
              TagsTile(
                use.tags,
                onEdited: editor?.call(
                  (v) => use.tags = v,
                ),
              ),
              NoteTile(
                use.note,
                onEdited: editor?.call(
                  (v) => use.note = v,
                ),
              ),
              TextSampleTiles(
                samples: use.samples,
                onEdited: editor?.call(
                  (v) => use.samples = v,
                ),
                icon: Icons.bookmark_rounded,
                translation: true,
              ),
            ],
          ),
        ),
      if (editor != null)
        Padding(
          padding: const EdgeInsets.all(8),
          child: ElevatedButton.icon(
            onPressed: () => MeaningTile.showEditor(
              context: context,
              callback: editor(
                (v) {
                  if (v != null) entry.uses.add(v);
                },
              ),
            ),
            icon: const Icon(Icons.add_rounded),
            label: const Text('Add use'),
          ),
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    final word = widget.word;
    return Scaffold(
      appBar: AppBar(
        leading: const RoundedBackButton(),
        title: LanguageFlag(
          GlobalStore.languages[word.language]!.flag,
          offset: const Offset(32, 0),
          scale: 15,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            tooltip: 'Share',
            icon: const Icon(Icons.share_rounded),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: word.language == EditorStore.language
          ? FloatingActionButton(
              onPressed: () {},
              tooltip: 'Edit',
              child: const Icon(Icons.edit_rounded),
            )
          : null,
      body: ListView(
        controller: widget.scroll,
        padding: const EdgeInsets.only(bottom: 76),
        children: [
          Segment(
            title: capitalize(word.forms.first.plain),
            subtitle: prettyTags(word.tags),
            body: word.note,
            children: [
              for (final f in word.forms) SampleTile(f),
            ],
          ),
          for (final u in word.uses)
            Segment(
              title: capitalize(u.term),
              subtitle: prettyTags(u.tags),
              body: u.note,
              children: [
                if (u.samples != null)
                  for (final s in u.samples!) SampleTile(s),
              ],
            ),
        ],
      ),
    );
  }
}
