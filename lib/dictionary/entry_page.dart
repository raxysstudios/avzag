import 'package:avzag/dictionary/meaning_tile.dart';
import 'package:avzag/store.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/widgets/page_title.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/widgets/segment_card.dart';
import 'package:avzag/widgets/tags_tile.dart';
import 'package:avzag/widgets/text_sample_tiles.dart';
import 'package:avzag/widgets/note_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'hit_tile.dart';
import 'entry.dart';

class EntryPage extends StatefulWidget {
  final Entry entry;
  final EntryHit hit;

  const EntryPage(
    this.entry,
    this.hit,
  );

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  late Entry entry;
  bool editing = false;

  void startEditing() {
    editing = true;
    entry = Entry.fromJson(entry.toJson());
  }

  @override
  void initState() {
    super.initState();
    entry = widget.entry;
    if (entry.forms.isEmpty) startEditing();
  }

  void submit() async {
    final collection = FirebaseFirestore.instance
        .collection('languages/${EditorStore.language}/dictionary');
    final json = entry.toJson();
    final upload = widget.hit.entryID.isEmpty
        ? collection.add(json)
        : collection.doc(widget.hit.entryID).update(json);
    showLoadingDialog(
      context,
      upload.then((_) => Navigator.pop(context)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (!editing) return true;
        final result = await showDialog<bool>(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('Discard edits?'),
              actions: [
                TextButton.icon(
                  onPressed: () => Navigator.pop(context, true),
                  icon: Icon(Icons.delete_outline),
                  label: Text('Discard'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.red),
                    overlayColor: MaterialStateProperty.all(Colors.red.shade50),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.edit_outlined),
                  label: Text('Edit'),
                ),
              ],
            );
          },
        );
        return result ?? false;
      },
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: Icon(
                editing ? Icons.close_outlined : Icons.arrow_back_outlined,
              ),
            ),
            title: editing
                ? Text('Entry editor')
                : PageTitle(
                    title: widget.hit.headword,
                    subtitle: widget.hit.language,
                  ),
            actions: [
              LanguageFlag(
                HomeStore.languages[widget.hit.language]!,
                offset: Offset(-30, 0),
                scale: 11,
              ),
            ],
          ),
          backgroundColor: Colors.blueGrey.shade50,
          floatingActionButton: EditorStore.language == null
              ? null
              : editing
                  ? FloatingActionButton(
                      onPressed: entry.uses.isEmpty || entry.forms.isEmpty
                          ? () => ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Row(
                                    children: [
                                      Icon(
                                        Icons.error_outline_outlined,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 8),
                                      Text(
                                        'Must have at least one form and one use.',
                                      ),
                                    ],
                                  ),
                                ),
                              )
                          : submit,
                      child: Icon(Icons.publish_outlined),
                      tooltip: 'Submit changes',
                    )
                  : FloatingActionButton(
                      onPressed: () => setState(() => startEditing()),
                      child: Icon(Icons.edit_outlined),
                      tooltip: 'Edit entry',
                    ),
          body: ListView(
            padding: const EdgeInsets.only(bottom: 64),
            children: [
              SegmentCard(
                children: [
                  TextSampleTiles(
                    samples: entry.forms,
                    onEdited: editing
                        ? (result) => setState(() {
                              entry.forms = result!;
                            })
                        : null,
                    icon: Icons.format_list_bulleted_outlined,
                    name: 'form',
                  ),
                  TagsTile(
                    entry.tags,
                    onEdited: editing
                        ? (result) => setState(() {
                              entry.tags = result;
                            })
                        : null,
                  ),
                  NoteTile(
                    entry.note,
                    onEdited: editing
                        ? (result) => setState(() {
                              entry.note = result;
                            })
                        : null,
                  ),
                ],
              ),
              for (final use in entry.uses)
                SegmentCard(
                  children: [
                    MeaningTile(
                      use,
                      onEdited: editing
                          ? (value) => setState(() {
                                if (value == null)
                                  entry.uses.remove(use);
                                else
                                  entry.uses.add(value);
                              })
                          : null,
                    ),
                    TagsTile(
                      use.tags,
                      onEdited: editing
                          ? (result) => setState(() {
                                use.tags = result;
                              })
                          : null,
                    ),
                    NoteTile(
                      use.note,
                      onEdited: editing
                          ? (result) => setState(() {
                                use.note = result;
                              })
                          : null,
                    ),
                    TextSampleTiles(
                      samples: use.samples,
                      onEdited: editing
                          ? (result) => setState(() {
                                use.samples = result;
                              })
                          : null,
                      icon: Icons.bookmark_outline,
                      translation: true,
                    ),
                  ],
                ),
              if (editing)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton.icon(
                    onPressed: () => MeaningTile.showEditor(
                      context: context,
                      callback: (value) {
                        if (value != null)
                          setState(() {
                            entry.uses.add(value);
                          });
                      },
                    ),
                    icon: Icon(Icons.add_outlined),
                    label: Text('Add use'),
                  ),
                ),
            ],
          )),
    );
  }
}
