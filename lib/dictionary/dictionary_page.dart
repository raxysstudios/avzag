import '../utils.dart';
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
  final inputController = TextEditingController();
  late Future<void>? loader;
  late Searcher searcher;

  bool scholar = false;
  bool useLists = false;

  @override
  void initState() {
    super.initState();
    loader = load(languages);
    searcher = Searcher(dictionaries);
    inputController.addListener(
      () => setState(
        () => searcher.search("", inputController.text),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    inputController.dispose();
    super.dispose();
  }

  showHelp() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          children: [
            Text("under construction"),
          ],
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
                visualDensity: VisualDensity(vertical: -4),
                onPressed: showHelp,
                icon: Icon(Icons.help_outline_outlined),
              ),
              // IconButton(
              //   onPressed: () => setState(() => useLists = !useLists),
              //   icon: Icon(Icons.format_list_bulleted_outlined),
              //   color: useLists ? Colors.blue : Colors.black,
              // ),
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
                  TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      hintText: "Enter query",
                      prefixIcon: Icon(Icons.search_outlined),
                    ),
                  ),
                  for (final m in searcher.results.entries) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      child: Text(
                        capitalize(m.key),
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    for (final l in m.value.entries)
                      for (final e in l.value)
                        InkWell(
                          onTap: () => showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Container(
                                height: 320,
                                child: EntryCard(
                                  e,
                                  scholar: scholar,
                                ),
                              );
                            },
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 4,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  capitalize(e.forms[0].plain),
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  capitalize(l.key),
                                  style: TextStyle(color: Colors.black54),
                                )
                              ],
                            ),
                          ),
                        ),
                    Divider(height: 0),
                  ],
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: Text(
                      inputController.text.isEmpty
                          ? "Start typing above to see results."
                          : "End of results.",
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
