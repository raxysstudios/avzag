import 'package:avzag/widgets/page_title.dart';
import 'entry_hit.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/utils.dart';
import 'package:avzag/widgets/text_sample.dart';
import 'package:avzag/widgets/note_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'entry.dart';

//  final Entry? entry;
//   final String? id;
//   EntryEditor({this.entry, this.id});

//   @override
// void initState() {
//   super.initState();
//   entry = widget.entry == null
//       ? Entry(forms: [], uses: [])
//       : Entry.fromJson(widget.entry!.toJson());
//   newItem = () => selectForm(form: null);
// }

// FloatingActionButton(
//               onPressed:
//                 entry.forms.isEmpty || entry.uses.isEmpty ? null : uploadEntry,,
//               child:  Icon(Icons.cloud_upload_outlined),
//             ),

//  void uploadEntry() async {
//   final collection = FirebaseFirestore.instance
//       .collection('languages/${EditorStore.language}/dictionary');
//   final json = entry.toJson();
//   widget.id == null
//       ? await collection.add(json)
//       : await collection.doc(widget.id).update(json);
//   Navigator.pop(context);
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Entry>>(
      future: widget.ref,
      builder: (context, snapshot) {
        final data = snapshot.data?.data();
        final done =
            snapshot.connectionState == ConnectionState.done && data != null;
        if (data != null && entry != data) entry = data;

        return Scaffold(
          appBar: AppBar(
            title: PageTitle(
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
          // floatingActionButton: EditorStore.language == null || !done
          //     ? null
          //     : FloatingActionButton(
          //         onPressed: () => Navigator.push(
          //           context,
          //           MaterialPageRoute(
          //             builder: (_) => EntryEditor(
          //               entry: entry,
          //               id: widget.hit.entryID,
          //             ),
          //           ),
          //         ),
          //         child: Icon(Icons.edit_outlined),
          //         tooltip: 'Edit this entry',
          //       ),
          body: Builder(builder: (context) {
            if (!done)
              return Center(
                child: CircularProgressIndicator(),
              );
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 8),
              children: [
                ListTile(
                  leading: Icon(Icons.tune_outlined),
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      for (final f in entry!.forms)
                        TextSampleWidget(f, row: true),
                    ],
                  ),
                ),
                if (entry!.tags != null)
                  ListTile(
                    leading: Icon(Icons.tag_outlined),
                    title: Text(
                      prettyTags(entry!.tags)!,
                      style: TextStyle(color: Colors.black54),
                    ),
                  ),
                NoteDisplay(
                  entry!.note,
                  onEdited: (note) => setState(() {
                    entry!.note = note;
                  }),
                ),
                for (final u in entry!.uses) ...[
                  Divider(),
                  ListTile(
                    leading: Icon(Icons.lightbulb_outline),
                    title: Text(
                      capitalize(u.term),
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    subtitle: u.definition == null
                        ? null
                        : Text(
                            u.definition!,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black87,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                  ),
                  if (u.tags != null)
                    ListTile(
                      leading: Icon(Icons.tag_outlined),
                      title: Text(
                        prettyTags(u.tags)!,
                        style: TextStyle(color: Colors.black54),
                      ),
                    ),
                  NoteDisplay(u.note),
                  if (u.samples != null)
                    for (var i = 0; i < u.samples!.length; i++)
                      ListTile(
                        leading: Icon(
                          Icons.bookmark_outline,
                          color: i == 0 ? null : Colors.transparent,
                        ),
                        title: TextSampleWidget(u.samples![i]),
                      )
                ],
              ],
            );
          }),
        );
      },
    );
  }
}
