import 'package:avzag/dictionary/entry_hit.dart';
import 'package:avzag/dictionary/meaning_tile.dart';
import 'package:avzag/store.dart';
import 'package:avzag/widgets/page_title.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/widgets/tags_tile.dart';
import 'package:avzag/widgets/text_sample_tiles.dart';
import 'package:avzag/widgets/note_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'entry.dart';

class EntryPage extends StatefulWidget {
  final Entry? entry;
  final EntryHit hit;

  const EntryPage(
    this.entry,
    this.hit,
  );

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  late final Entry entry;
  late bool editing;

  @override
  void initState() {
    super.initState();
    entry = widget.entry == null ? Entry(forms: [], uses: []) : widget.entry!;
    // Entry.fromJson(widget.entry!.toJson());
    editing = widget.entry == null;
  }

  void submit() async {
    // final collection = FirebaseFirestore.instance
    //     .collection('languages/${EditorStore.language}/dictionary');
    // final json = entry!.toJson();
    // widget.hit == null
    //     ? await collection.add(json)
    //     : await collection.doc(widget.hit.entryID).update(json);
    // Navigator.pop(context);
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
                scale: 7,
              ),
            ],
          ),
          backgroundColor: Colors.blueGrey.shade50,
          floatingActionButton: EditorStore.language == null
              ? null
              : editing
                  ? FloatingActionButton(
                      onPressed: entry.uses.isEmpty || entry.forms.isEmpty
                          ? null
                          : submit,
                      child: Icon(Icons.cloud_upload_outlined),
                      tooltip: 'Submit changes',
                    )
                  : FloatingActionButton(
                      onPressed: () => setState(() {
                        editing = true;
                      }),
                      child: Icon(Icons.edit_outlined),
                      tooltip: 'Edit entry',
                    ),
          body: ListView(
            padding: const EdgeInsets.only(top: 16, bottom: 64),
            children: [
              Card(
                margin: EdgeInsets.zero,
                shape: RoundedRectangleBorder(),
                child: Column(
                  children: [
                    TextSampleTiles(
                      samples: entry.forms,
                      onEdited: editing
                          ? (result) => setState(() {
                                entry.forms = result!;
                              })
                          : null,
                      icon: Icons.format_list_bulleted_outlined,
                      noEmpty: true,
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
              ),
              for (final use in entry.uses)
                Card(
                  margin: const EdgeInsets.only(top: 16),
                  shape: RoundedRectangleBorder(),
                  child: Column(
                    children: [
                      ConceptTile(
                        use,
                        onEdited: editing
                            ? (result) => setState(() {
                                  if (result == null)
                                    entry.uses.remove(use);
                                  else {
                                    use.term = result[0]!;
                                    use.definition = result[1];
                                  }
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
                      NoteTile(use.note),
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
                ),
              if (editing)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.add_outlined),
                    label: Text('Add use'),
                  ),
                ),
            ],
          )),
    );
  }
}
