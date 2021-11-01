import 'package:avzag/dictionary/hit_tile.dart';

import 'package:avzag/dictionary/meaning_tile.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/widgets/danger_dialog.dart';
import 'package:avzag/widgets/editor_utils.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/widgets/page_title.dart';
import 'package:avzag/widgets/snackbar_manager.dart';
import 'package:avzag/widgets/tags_tile.dart';
import 'package:avzag/widgets/text_sample_tiles.dart';
import 'package:avzag/widgets/note_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'entry.dart';

class EntryPage extends StatelessWidget {
  final Entry entry;
  final EntryHit? hit;
  final EditorCallback? editor;

  final ScrollController? scroll;

  const EntryPage(
    this.entry, {
    this.hit,
    this.scroll,
    this.editor,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: editor != null
            ? PageTitle(
                'Entry editor',
                subtitle: GlobalStore.editing,
              )
            : PageTitle(
                entry.forms[0].plain,
                subtitle: entry.language,
              ),
        actions: [
          Opacity(
            opacity: 0.4,
            child: LanguageFlag(
              GlobalStore.languages[entry.language]!.flag,
              offset: const Offset(-40, 4),
              scale: 9,
            ),
          ),
        ],
      ),
      floatingActionButton: Builder(
        builder: (context) {
          if (entry.language != GlobalStore.editing) return const SizedBox();
          if (editor == null) {
            return FloatingActionButton.extended(
              onPressed: () => Navigator.of(context).pop(false),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit'),
            );
          }
          final theme = Theme.of(context).colorScheme;
          return SpeedDial(
            icon: Icons.done_all_outlined,
            activeIcon: Icons.close_outlined,
            backgroundColor: theme.primary,
            foregroundColor: theme.onPrimary,
            activeBackgroundColor: theme.surface,
            activeForegroundColor: theme.onSurface,
            spaceBetweenChildren: 9,
            spacing: 7,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.upload_outlined),
                backgroundColor: Colors.blue,
                foregroundColor: Colors.white,
                label: 'Submit changes',
                onTap: () async {
                  if (await submit(context)) {
                    Navigator.of(context).pop(true);
                  }
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.cancel_outlined),
                label: 'Discard changes',
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                onTap: () {
                  Navigator.of(context).pop(true);
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.delete_outline),
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                label: 'Delete entry',
                visible: true,
                onTap: () async {
                  if (await delete(context)) {
                    Navigator.of(context).pop(true);
                  }
                },
              ),
            ],
          );
        },
      ),
      body: ListView(
        controller: scroll,
        padding: const EdgeInsets.only(bottom: 76),
        children: [
          Column(
            children: [
              TextSampleTiles(
                samples: entry.forms,
                onEdited: editor?.call(
                  (v) => entry.forms = v ?? [],
                ),
                icon: Icons.layers_outlined,
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
                    icon: Icons.bookmark_outline,
                    translation: true,
                  ),
                ],
              ),
            ),
          if (editor != null)
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton.icon(
                onPressed: () => MeaningTile.showEditor(
                  context: context,
                  callback: editor!(
                    (v) {
                      if (v != null) entry.uses.add(v);
                    },
                  ),
                ),
                icon: const Icon(Icons.add_outlined),
                label: const Text('Add use'),
              ),
            )
        ],
      ),
    );
  }

  Future<bool> submit(BuildContext context) async {
    if (entry.uses.isEmpty || entry.forms.isEmpty) {
      showSnackbar(
        context,
        text: 'Must have at least a form and a use.',
      );
      return false;
    }
    await showLoadingDialog(
      context,
      FirebaseFirestore.instance
          .collection('dictionary')
          .doc(hit?.entryID)
          .set(entry.toJson()),
    );
    return true;
  }

  Future<bool> delete(BuildContext context) async {
    if (entry.uses.isNotEmpty) {
      showSnackbar(
        context,
        text: 'Remove all uses first.',
      );
      return false;
    }
    final confirm = await showDangerDialog(
      context,
      'Delete entry?',
      confirmText: 'Delete',
      rejectText: 'Keep',
    );
    if (confirm) {
      await showLoadingDialog(
        context,
        FirebaseFirestore.instance.doc('dictionary/${hit?.entryID}').delete(),
      );
      return true;
    }
    return false;
  }
}
