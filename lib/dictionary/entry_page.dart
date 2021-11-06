import 'package:avzag/utils/contribution.dart';

import 'package:avzag/dictionary/meaning_tile.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/widgets/danger_dialog.dart';
import 'package:avzag/utils/editor_utils.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/widgets/page_title.dart';
import 'package:avzag/utils/snackbar_manager.dart';
import 'package:avzag/widgets/tags_tile.dart';
import 'package:avzag/widgets/text_sample_tiles.dart';
import 'package:avzag/widgets/note_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'entry.dart';

class EntryPage extends StatefulWidget {
  final Entry entry;
  final Entry? sourceEntry;
  final ValueSetter<Entry?>? onEdited;
  final bool editing;
  final ScrollController? scroll;

  const EntryPage(
    this.entry, {
    this.onEdited,
    this.sourceEntry,
    this.editing = false,
    this.scroll,
    Key? key,
  }) : super(key: key);

  @override
  State<EntryPage> createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  Entry get entry => widget.entry;
  EditorCallback? editor;

  bool get isReviewing =>
      EditorStore.isAdmin &&
      entry.language == EditorStore.language &&
      entry.contribution != null;
  bool showSource = false;

  @override
  void initState() {
    super.initState();
    if (widget.editing) startEditing();
  }

  List<Widget> buildEntry(
    BuildContext context,
    Entry entry, [
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
              callback: editor(
                (v) {
                  if (v != null) entry.uses.add(v);
                },
              ),
            ),
            icon: const Icon(Icons.add_outlined),
            label: const Text('Add use'),
          ),
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: editor == null
            ? PageTitle(
                entry.forms[0].plain,
                subtitle: entry.language,
              )
            : PageTitle(
                'Entry editor',
                subtitle: EditorStore.language,
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
          if (entry.language == EditorStore.language) {
            if (editor != null || isReviewing) {
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
                        exit(context);
                      }
                    },
                  ),
                  if (!isReviewing)
                    SpeedDialChild(
                      child: const Icon(Icons.cancel_outlined),
                      label: 'Discard changes',
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      onTap: () => exit(context),
                    ),
                  if (entry.id != null && EditorStore.isAdmin)
                    SpeedDialChild(
                      child: const Icon(Icons.delete_outline),
                      backgroundColor: Colors.red,
                      foregroundColor: Colors.white,
                      label: 'Delete entry',
                      visible: true,
                      onTap: () async {
                        if (await delete(context)) {
                          exit(context);
                        }
                      },
                    ),
                ],
              );
            }
            if (entry.contribution == null) {
              return FloatingActionButton.extended(
                onPressed: startEditing,
                icon: const Icon(Icons.edit_outlined),
                label: const Text('Edit'),
              );
            }
          }
          return const SizedBox();
        },
      ),
      body: ListView(
        controller: widget.scroll,
        padding: const EdgeInsets.only(bottom: 76),
        children: [
          if (isReviewing) ...[
            SwitchListTile(
              value: !showSource,
              onChanged: widget.sourceEntry == null
                  ? null
                  : (v) => setState(() {
                        showSource = !v;
                      }),
              secondary: const Icon(Icons.pending_actions_outlined),
              title: const Text('Reviewing contribution'),
            ),
            const Divider(),
          ],
          ...buildEntry(
            context,
            showSource ? widget.sourceEntry! : entry,
            isReviewing ? null : editor,
          ),
        ],
      ),
    );
  }

  Widget buildHeader(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6,
      ),
    );
  }

  Future<bool> submit(BuildContext context) async {
    if (!isReviewing && (this.entry.uses.isEmpty || this.entry.forms.isEmpty)) {
      showSnackbar(
        context,
        text: 'Must have at least a form and a use.',
      );
      return false;
    }
    final docId = isReviewing
        ? this.entry.contribution?.overwriteId
        : EditorStore.isAdmin
            ? this.entry.id
            : null;
    final entry = Entry.fromJson(this.entry.toJson(), this.entry.id);
    entry.contribution = EditorStore.isAdmin
        ? null
        : Contribution(
            EditorStore.uid!,
            overwriteId: entry.id,
          );

    return await showLoadingDialog<bool>(
          context,
          FirebaseFirestore.instance
              .collection('dictionary')
              .doc(docId)
              .set(entry.toJson())
              .then((_) {
            if (isReviewing) {
              return FirebaseFirestore.instance
                  .collection('dictionary')
                  .doc(entry.id)
                  .delete();
            }
          }).then((_) => true),
        ) ??
        false;
  }

  Future<bool> delete(BuildContext context) async {
    final confirm = await showDangerDialog(
      context,
      'Delete entry?',
      confirmText: 'Delete',
      rejectText: 'Keep',
    );
    if (confirm) {
      return await showLoadingDialog<bool>(
            context,
            FirebaseFirestore.instance
                .collection('dictionary')
                .doc(entry.id)
                .delete()
                .then((_) => true),
          ) ??
          false;
    }
    return false;
  }

  void exit(BuildContext context) {
    widget.onEdited?.call(null);
    Navigator.pop(context);
  }

  void startEditing() {
    widget.onEdited?.call(entry);
    setState(() {
      editor = getEditor(setState);
    });
  }
}
