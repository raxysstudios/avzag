import 'package:avzag/dictionary/search/entry_hit.dart';
import 'package:avzag/store.dart';
import 'package:avzag/widgets/column_tile.dart';
import 'package:avzag/dictionary/sample/sample_display.dart';
import 'package:avzag/dictionary/use/use_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../../widgets/note_display.dart';
import '../../utils.dart';
import 'entry.dart';
import 'entry_editor.dart';

class EntryDisplay extends StatelessWidget {
  final EntryHit hit;
  final bool scholar;
  final List<Widget>? actions;
  late final DocumentReference<Entry> doc;

  EntryDisplay(
    this.hit, {
    this.actions,
    this.scholar = false,
  }) {
    doc = FirebaseFirestore.instance
        .doc('meta/dictionary/concepts/${hit.entryID}')
        .withConverter(
          fromFirestore: (snapshot, _) => Entry.fromJson(snapshot.data()!),
          toFirestore: (Entry object, _) => object.toJson(),
        );
  }

  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Entry>>(
      future: doc.get(),
      builder: (_, snapshot) {
        if (snapshot.connectionState != ConnectionState.done)
          return CircularProgressIndicator();

        final entry = snapshot.data!.data()!;
        return Scaffold(
          appBar: AppBar(
            title: Text(capitalize(entry.forms[0].plain)),
            actions: actions,
          ),
          floatingActionButton: EditorStore.language == null
              ? null
              : FloatingActionButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => EntryEditor(
                        entry: entry,
                        id: hit.entryID,
                      ),
                    ),
                  ),
                  child: Icon(Icons.edit_outlined),
                  tooltip: 'Edit this entry',
                ),
          body: ListView(
            children: [
              // ColumnTile(
              //   Text(
              //     capitalize(entry.forms[0].plain),
              //     style: TextStyle(
              //       fontSize: 18,
              //       fontWeight: FontWeight.w600,
              //     ),
              //   ),
              //   subtitle: prettyTags(scholar ? entry.tags : null),
              //   leading: leading,
              //   trailing: trailing,
              //   gap: 20,
              //   padding: const EdgeInsets.symmetric(horizontal: 4),
              // ),
              NoteDisplay(entry.note),
              for (final u in entry.uses) UseDisplay(u, scholar: scholar),
              ColumnTile(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final f in entry.forms)
                      SampleDisplay(
                        f,
                        scholar: scholar,
                        row: true,
                      ),
                  ],
                ),
                leading: Icon(Icons.tune_outlined),
              ),
            ],
          ),
        );
      },
    );
  }
}
