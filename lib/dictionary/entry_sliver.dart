import 'package:avzag/dictionary/meaning_tile.dart';
import 'package:avzag/widgets/tags_tile.dart';
import 'package:avzag/widgets/text_sample_tiles.dart';
import 'package:avzag/widgets/note_tile.dart';
import 'package:flutter/material.dart';
import 'entry.dart';

class EntrySliver extends StatelessWidget {
  final Entry entry;
  final ValueSetter<Entry>? onEdited;

  const EntrySliver(
    this.entry, {
    this.onEdited,
  });

  bool get editing => onEdited != null;
  ValueSetter<VoidCallback> get edit => (e) {
        e();
        onEdited!(entry);
      };

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildListDelegate(
        [
          Card(
            child: Column(
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
          ),
          for (final use in entry.uses)
            Card(
              child: Column(
                children: [
                  MeaningTile(
                    use,
                    onEdited: editing
                        ? (v) => edit(() {
                              if (v == null)
                                entry.uses.remove(use);
                              else
                                entry.uses[entry.uses.indexOf(use)] = v;
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
                icon: Icon(Icons.add_outlined),
                label: Text('Add use'),
              ),
            )
        ],
      ),
    );
  }
}
