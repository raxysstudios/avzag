import 'package:avzag/store.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/widgets/segment_card.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'entry.dart';
import 'entry_page.dart';
import 'search_controller.dart';
import 'package:avzag/utils.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'entry_hit.dart';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  EntryHitSearch? search = {};

  void openEntry(EntryHit hit) {
    showLoadingDialog<Entry>(
      context,
      FirebaseFirestore.instance
          .doc('languages/${hit.language}/dictionary/${hit.entryID}')
          .withConverter(
            fromFirestore: (snapshot, _) => Entry.fromJson(snapshot.data()!),
            toFirestore: (Entry object, _) => object.toJson(),
          )
          .get()
          .then((snapshot) => Future.value(snapshot.data())),
      callback: (result) => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => EntryPage(result, hit),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionary'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(64),
          child: SearchController(
            (s) => setState(() {
              search = s;
            }),
          ),
        ),
      ),
      drawer: NavDraver(title: 'dictionary'),
      floatingActionButton: EditorStore.language == null
          ? null
          : FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntryPage(
                    Entry(forms: [], uses: []),
                    EntryHit(
                      entryID: '',
                      headword: '',
                      language: EditorStore.language!,
                      term: '',
                    ),
                  ),
                ),
              ),
              child: Icon(
                Icons.add_outlined,
              ),
              tooltip: 'Add new entry',
            ),
      backgroundColor: Colors.blueGrey.shade50,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 64),
        children: [
          for (final hits in search!.entries)
            SegmentCard(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    capitalize(hits.key),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                for (final hit in hits.value)
                  ListTile(
                    title: Text(
                      capitalize(hit.headword),
                      style: TextStyle(fontSize: 16),
                    ),
                    subtitle:
                        hit.definition == null ? null : Text(hit.definition!),
                    trailing: Text(
                      capitalize(hit.language),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 14,
                      ),
                    ),
                    onTap: () => openEntry(hit),
                  ),
              ],
            )
        ],
      ),
    );
  }
}
