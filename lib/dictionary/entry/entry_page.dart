import 'package:avzag/dictionary/search/entry_hit.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:avzag/dictionary/sample/sample_display.dart';
import 'package:avzag/dictionary/use/use_display.dart';
import 'package:avzag/widgets/note_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'entry.dart';
import 'entry_editor.dart';

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
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Entry>>(
      future: widget.ref,
      builder: (_, snapshot) {
        final done = snapshot.connectionState == ConnectionState.done;
        final entry = snapshot.data?.data();
        return Scaffold(
          appBar: AppBar(
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: capitalize(widget.hit.headword) + '\n',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextSpan(
                    text: capitalize(widget.hit.language),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.black54,
                      fontWeight: FontWeight.w500,
                    ),
                  )
                ],
              ),
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
              : FloatingActionButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EntryEditor(
                        entry: entry,
                        id: widget.hit.entryID,
                      ),
                    ),
                  ),
                  child: Icon(Icons.edit_outlined),
                  tooltip: 'Edit this entry',
                ),
          body: done
              ? ListView(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  children: [
                    ListTile(
                      leading: Icon(Icons.tune_outlined),
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final f in entry!.forms)
                            SampleDisplay(f, row: true),
                        ],
                      ),
                    ),
                    if (entry.tags != null)
                      ListTile(
                        leading: Icon(Icons.tag_outlined),
                        title: Text(
                          prettyTags(entry.tags)!,
                          style: TextStyle(color: Colors.black54),
                        ),
                      ),
                    NoteDisplay(entry.note),
                    for (final u in entry.uses) ...[
                      Divider(),
                      UseDisplay(u),
                    ],
                  ],
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
        );
      },
    );
  }
}
