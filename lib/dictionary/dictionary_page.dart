import 'entry_card.dart';
import 'searcher.dart';
import 'store.dart';
import 'package:avzag/nav_drawer.dart';
import 'package:flutter/material.dart';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  final languages = ['iron', 'kaitag'];
  late Future<void>? loader;
  late Searcher searcher;

  bool scholar = false;
  bool useLists = false;

  @override
  void initState() {
    super.initState();
    loader = load(languages);
    searcher = Searcher(dictionaries);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loader,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
        final languages = dictionaries.keys;
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
                color: useLists ? Colors.blue : Colors.black,
              ),
              VerticalDivider(width: 8),
            ],
          ),
          drawer: NavDraver(title: "Dictionary"),
          body: Builder(
            builder: (context) {
              if (snapshot.hasError || languages.isEmpty)
                return Text("Something went wrong.");
              if (snapshot.connectionState != ConnectionState.done)
                return Text("Loading, please wait...");
              return ListView(
                children: [
                  TextField(
                    onChanged: (q) => setState(() => searcher.search("", q)),
                  ),
                  for (final m in searcher.results.entries) ...[
                    Text(
                      m.key,
                      style: TextStyle(
                        color: Colors.black54,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    for (final l in m.value.entries) ...[
                      Text(
                        l.key,
                        style: TextStyle(
                          color: Colors.black54,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      for (final e in l.value) EntryCard(e, scholar: scholar),
                    ]
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
