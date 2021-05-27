import 'package:avzag/dictionary/entry_card.dart';
import 'package:avzag/nav_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'models.dart';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final languages = ['iron', 'kaitag'];
  final Map<String, List<Entry>> dictionaries = {};
  Future<List<String?>>? loader;

  bool scholar = false;
  bool useLists = false;

  @override
  void initState() {
    super.initState();
    loader = Future.wait(
      languages.map((l) {
        return FirebaseFirestore.instance
            .collection('languages/$l/dictionary')
            .withConverter(
              fromFirestore: (snapshot, _) => Entry.fromJson(snapshot.data()!),
              toFirestore: (Entry language, _) => language.toJson(),
            )
            .get()
            .then((d) {
          dictionaries[l] = d.docs.map((e) => e.data()).toList();
          return d.docs.isEmpty ? null : l;
        });
      }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Iterable<String?>>(
      future: loader,
      builder: (
        BuildContext context,
        AsyncSnapshot<Iterable<String?>> snapshot,
      ) {
        final languages = snapshot.data?.where((l) => l != null).toList();
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Dictionaries",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => setState(() => scholar = !scholar),
                icon: Icon(Icons.school_outlined),
                color: scholar ? Colors.blue : Colors.black,
              ),
              IconButton(
                onPressed: () => setState(() => useLists = !useLists),
                icon: Icon(Icons.format_list_bulleted_outlined),
                color: scholar ? Colors.blue : Colors.black,
              ),
              VerticalDivider(width: 8),
            ],
          ),
          drawer: NavDraver(title: "Dictionary"),
          body: Builder(
            builder: (context) {
              if (snapshot.hasError || languages == null)
                return Text("Something went wrong.");
              if (snapshot.connectionState != ConnectionState.done)
                return Text("Loading, please wait...");
              return ListView(
                children: [
                  for (final l in languages) ...[
                    Text(
                      l!,
                      style: TextStyle(fontSize: 24),
                    ),
                    for (final e in dictionaries[l]!)
                      EntryCard(e, scholar: scholar),
                  ],
                ],
              );
            },
          ),
        );
      },
    );
  }
}
