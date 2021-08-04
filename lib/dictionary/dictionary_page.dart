import 'package:avzag/dictionary/meaning_tile.dart';
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
  var hits = MapEntry('', <EntryHit>[]);

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
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            title: Text('Dictionary'),
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(64),
              child: SearchController(
                (s) => setState(() {
                  hits = s;
                }),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 64),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final hit = hits.value[index];
                  return SegmentCard(
                    marginTop: index == 0 ||
                            (hits.key.isEmpty &&
                                hits.value[index - 1].term != hit.term)
                        ? 16
                        : 0,
                    children: [
                      ListTile(
                        title: Text(
                          capitalize(hit.headword),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        subtitle: MeaningTile.buildRichText(
                          hit.term,
                          hit.definition,
                          subtitle: true,
                        ),
                        trailing: hits.key.isEmpty
                            ? Text(
                                capitalize(hit.language),
                                style: TextStyle(
                                  color: Colors.black54,
                                  fontSize: 14,
                                ),
                              )
                            : null,
                        onTap: () => openEntry(hit),
                      ),
                    ],
                  );
                },
                childCount: hits.value.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
