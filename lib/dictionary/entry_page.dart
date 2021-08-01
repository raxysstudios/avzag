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
import 'entry_hit.dart';
import 'entry.dart';

//   @override
// void initState() {
//   super.initState();
//   entry = widget.entry == null
//       ? Entry(forms: [], uses: [])
//       : Entry.fromJson(widget.entry!.toJson());
//   newItem = () => selectForm(form: null);
// }

class EntryPage extends StatefulWidget {
  final EntryHit hit;
  late final Future<DocumentSnapshot<Entry>> ref = FirebaseFirestore.instance
      .doc('languages/${hit.language}/dictionary/${hit.entryID}')
      .withConverter(
        fromFirestore: (snapshot, _) => Entry.fromJson(snapshot.data()!),
        toFirestore: (Entry object, _) => object.toJson(),
      )
      .get();

  EntryPage(this.hit);

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  Entry? entry;
  bool editing = false;
  String test = '';

  @override
  void initState() {
    super.initState();
  }

  void submit() async {
    final collection = FirebaseFirestore.instance
        .collection('languages/${EditorStore.language}/dictionary');
    final json = entry!.toJson();
    widget.hit == null
        ? await collection.add(json)
        : await collection.doc(widget.hit.entryID).update(json);
    Navigator.pop(context);
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
                  label: Text('DISCARD'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.red),
                    overlayColor: MaterialStateProperty.all(Colors.red.shade50),
                  ),
                ),
                TextButton.icon(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.edit_outlined),
                  label: Text('EDIT'),
                ),
              ],
            );
          },
        );
        return result ?? false;
      },
      child: FutureBuilder<DocumentSnapshot<Entry>>(
        future: widget.ref,
        builder: (context, snapshot) {
          final data = snapshot.data?.data();
          if (data != null && entry == null) entry = data;
          final done =
              snapshot.connectionState == ConnectionState.done && entry != null;

          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                onPressed: () => Navigator.maybePop(context),
                icon: Icon(
                  editing ? Icons.close_outlined : Icons.arrow_back_outlined,
                ),
              ),
              title: editing
                  ? Text('Editing entry')
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
            floatingActionButton: EditorStore.language == null || !done
                ? null
                : editing
                    ? FloatingActionButton(
                        onPressed: entry!.uses.isEmpty || entry!.forms.isEmpty
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
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                Text(test),
                if (!done)
                  LinearProgressIndicator()
                else ...[
                  ListTile(
                    leading: Icon(Icons.tune_outlined),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        for (final f in entry!.forms)
                          TextSampleTiles(f, row: true),
                      ],
                    ),
                  ),
                  TagsTile(
                    entry!.tags,
                    onEdited: editing
                        ? (result) => setState(() {
                              entry!.tags = result;
                            })
                        : null,
                  ),
                  NoteTile(
                    entry!.note,
                    onEdited: editing
                        ? (result) => setState(() {
                              entry!.note = result;
                            })
                        : null,
                  ),
                  for (final u in entry!.uses) ...[
                    Divider(),
                    ConceptTile(
                      u,
                      onEdited: editing
                          ? (result) => setState(() {
                                if (result == null)
                                  entry!.uses.remove(u);
                                else {
                                  u.term = result[0]!;
                                  u.definition = result[1];
                                }
                              })
                          : null,
                    ),
                    TagsTile(
                      u.tags,
                      onEdited: editing
                          ? (result) => setState(() {
                                u.tags = result;
                              })
                          : null,
                    ),
                    NoteTile(u.note),
                    if (u.samples != null)
                      for (var i = 0; i < u.samples!.length; i++)
                        ListTile(
                          leading: Icon(
                            Icons.bookmark_outline,
                            color: i == 0 ? null : Colors.transparent,
                          ),
                          title: TextSampleTiles(u.samples![i]),
                        )
                  ],
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}
