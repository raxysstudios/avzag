import 'package:avzag/dictionary/hit_tile.dart';
import 'package:avzag/dictionary/meaning_tile.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/widgets/page_title.dart';
import 'package:avzag/widgets/tags_tile.dart';
import 'package:avzag/widgets/text_sample_tiles.dart';
import 'package:avzag/widgets/note_tile.dart';
import 'package:flutter/material.dart';
import 'entry.dart';

class EntryPage extends StatelessWidget {
  final Entry entry;
  final EntryHit hit;
  final ValueSetter<Entry>? onEdited;
  final ScrollController? scroll;

  const EntryPage(
    this.entry, {
    required this.hit,
    this.onEdited,
    this.scroll,
    Key? key,
  }) : super(key: key);

  bool get editing => onEdited != null;
  ValueSetter<VoidCallback> get edit => (e) {
        e();
        onEdited!(entry);
      };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: PageTitle(
          title: editing ? 'Entry editor' : hit.headword,
          subtitle: editing ? GlobalStore.editing : hit.language,
        ),
        actions: [
          Opacity(
            opacity: 0.4,
            child: LanguageFlag(
              GlobalStore
                  .languages[editing ? GlobalStore.editing : hit.language]!
                  .flag,
              offset: const Offset(-40, 4),
              scale: 9,
            ),
          ),
        ],
      ),
      body: ListView(
        controller: scroll,
        padding: const EdgeInsets.only(bottom: 76),
        children: [
          Column(
            children: [
              TextSampleTiles(
                samples: entry.forms,
                onEdited:
                    editing ? (v) => edit(() => entry.forms = v ?? []) : null,
                icon: Icons.layers_outlined,
                name: 'form',
              ),
              TagsTile(
                entry.tags,
                onEdited: editing ? (v) => edit(() => entry.tags = v) : null,
              ),
              NoteTile(
                entry.note,
                onEdited: editing ? (v) => edit(() => entry.note = v) : null,
              ),
            ],
          ),
          for (final use in entry.uses)
            Card(
              child: Column(
                children: [
                  MeaningTile(
                    use,
                    onEdited: editing
                        ? (v) => edit(() {
                              if (v == null) {
                                entry.uses.remove(use);
                              } else {
                                entry.uses[entry.uses.indexOf(use)] = v;
                              }
                            })
                        : null,
                  ),
                  TagsTile(
                    use.tags,
                    onEdited: editing ? (v) => edit(() => use.tags = v) : null,
                  ),
                  NoteTile(
                    use.note,
                    onEdited: editing ? (v) => edit(() => use.note = v) : null,
                  ),
                  TextSampleTiles(
                    samples: use.samples,
                    onEdited:
                        editing ? (v) => edit(() => use.samples = v) : null,
                    icon: Icons.bookmark_outline,
                    translation: true,
                  ),
                ],
              ),
            ),
          if (editing)
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton.icon(
                onPressed: () => MeaningTile.showEditor(
                  context: context,
                  callback: (v) {
                    if (v != null) edit(() => entry.uses.add(v));
                  },
                ),
                icon: const Icon(Icons.add_outlined),
                label: const Text('Add use'),
              ),
            )
        ],
      ),
    );
  }
}
