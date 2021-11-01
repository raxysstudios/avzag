import 'package:avzag/dictionary/editor_controller.dart';
import 'package:avzag/dictionary/meaning_tile.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/widgets/danger_dialog.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/widgets/page_title.dart';
import 'package:avzag/widgets/snackbar_manager.dart';
import 'package:avzag/widgets/tags_tile.dart';
import 'package:avzag/widgets/text_sample_tiles.dart';
import 'package:avzag/widgets/note_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:provider/provider.dart';
import 'entry.dart';
import 'use.dart';

class EntryPage extends StatelessWidget {
  final Entry entry;
  final ScrollController? scroll;

  const EntryPage(
    this.entry, {
    this.scroll,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final editor = context.watch<EditorController<Entry>>();
    return Scaffold(
      appBar: AppBar(
        title: editor.editing
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
          if (!editor.editing) {
            return FloatingActionButton.extended(
              onPressed: () => editor.startEditing(entry, editor.id),
              icon: const Icon(Icons.edit_outlined),
              label: const Text('Edit'),
            );
          }
          return SpeedDial(
            icon: Icons.done_all_outlined,
            activeIcon: Icons.remove_done_outlined,
            // label: const Text('Finish editing'),
            // activeLabel: const Text('Continue editing'),
            // buttonSize: 48,
            spaceBetweenChildren: 9,
            spacing: 7,
            children: [
              SpeedDialChild(
                child: const Icon(Icons.upload_outlined),
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                label: 'Submit changes',
                onTap: () async {
                  if (await submit(context)) {
                    Navigator.of(context).pop();
                  }
                },
              ),
              SpeedDialChild(
                child: const Icon(Icons.cancel_outlined),
                label: 'Discard changes',
                onTap: () {
                  editor.stopEditing();
                  Navigator.of(context).pop();
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
                    Navigator.of(context).pop();
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
                onEdited: editor.edit<List<TextSample>?>(
                  (v) => entry.forms = v ?? [],
                ),
                icon: Icons.layers_outlined,
                name: 'form',
              ),
              TagsTile(
                entry.tags,
                onEdited: editor.edit<List<String>?>(
                  (v) => entry.tags = v,
                ),
              ),
              NoteTile(
                entry.note,
                onEdited: editor.edit<String?>(
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
                    onEdited: editor.edit<Use?>((v) {
                      if (v == null) {
                        entry.uses.remove(use);
                      } else {
                        entry.uses[entry.uses.indexOf(use)] = v;
                      }
                    }),
                  ),
                  TagsTile(
                    use.tags,
                    onEdited: editor.edit<List<String>?>(
                      (v) => use.tags = v,
                    ),
                  ),
                  NoteTile(
                    use.note,
                    onEdited: editor.edit<String?>(
                      (v) => use.note = v,
                    ),
                  ),
                  TextSampleTiles(
                    samples: use.samples,
                    onEdited: editor.edit<List<TextSample>?>(
                      (v) => use.samples = v,
                    ),
                    icon: Icons.bookmark_outline,
                    translation: true,
                  ),
                ],
              ),
            ),
          if (editor.editing)
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton.icon(
                onPressed: () => MeaningTile.showEditor(
                  context: context,
                  callback: editor.edit<Use?>(
                    (v) {
                      if (v != null) entry.uses.add(v);
                    },
                  )!,
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
    final editor = context.read<EditorController<Entry>>();
    final entry = editor.object;
    if (entry == null) return false;
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
          .doc(editor.id)
          .set(entry.toJson()),
    );
    return true;
  }

  Future<bool> delete(BuildContext context) async {
    final editor = context.read<EditorController<Entry>>();
    final entry = editor.object;
    if (entry == null || editor.id == null) return false;
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
        FirebaseFirestore.instance.doc('dictionary/${editor.id}').delete(),
      );
      return true;
    }
    return false;
  }
}
