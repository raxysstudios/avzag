import 'package:avzag/dictionary/search_controller.dart';
import 'package:avzag/dictionary/searcher.dart';
import 'package:avzag/dictionary/store.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/utils.dart';
import 'entry/entry_display.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:flutter/material.dart';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  late Searcher searcher;
  late Future<void>? loader;
  bool useScholar = false;

  @override
  void initState() {
    super.initState();
    searcher = Searcher(dictionaries, setState);

    loader = loadDictionaries(
      languages.map((l) => l.name),
    );
  }

  showHelp() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loader,
      builder: (
        BuildContext context,
        AsyncSnapshot snapshot,
      ) {
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
                onPressed: () => setState(() => useScholar = !useScholar),
                icon: Icon(Icons.school_outlined),
                color: useScholar ? Colors.blue : Colors.black,
              ),
              IconButton(
                onPressed: showHelp,
                icon: Icon(Icons.help_outline_outlined),
              ),
              SizedBox(width: 4),
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
                  SearchController(searcher),
                  Divider(height: 0),
                  for (final m in searcher.results.entries) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        capitalize(m.key),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    for (final l in m.value.entries)
                      for (final e in l.value)
                        ListTile(
                          dense: true,
                          title: Text(
                            capitalize(e.forms[0].plain),
                            style: TextStyle(fontSize: 18),
                          ),
                          trailing: Text(
                            capitalize(l.key),
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 320,
                                child: EntryDisplay(
                                  e,
                                  scholar: useScholar,
                                ),
                              );
                            },
                          ),
                        ),
                    Divider(height: 0),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      searcher.executing
                          ? "Searching..."
                          : searcher.done
                              ? "End of results."
                              : "Start typing above to see results.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
