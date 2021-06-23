import 'package:avzag/column_tile.dart';
import 'package:avzag/dictionary/entry/entry.dart';
import 'package:avzag/dictionary/help_button.dart';
import 'package:avzag/dictionary/search_controller.dart';
import 'package:avzag/dictionary/searcher.dart';
import 'package:avzag/dictionary/store.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'entry/entry_display.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'entry/entry_editor.dart';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  late Searcher searcher;
  Entry? entry;
  String language = '';
  bool useScholar = false;
  final _pageController = PageController();

  @override
  void initState() {
    super.initState();
    searcher = Searcher(DictionaryStore.dictionaries, setState);
  }

  void openPage(int index) {
    _pageController.animateToPage(
      index,
      duration: Duration(milliseconds: 200),
      curve: standardEasing,
    );
  }

  void openEditor({Entry? entry}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (c) => EntryEditor(
          entry: entry,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionaries'),
        actions: [
          HelpButton(),
          SizedBox(width: 4),
        ],
      ),
      drawer: NavDraver(title: 'dictionary'),
      body: PageView(
        controller: _pageController,
        children: [
          Column(
            children: [
              SearchController(searcher),
              Divider(height: 0),
              Expanded(
                child: ListView(
                  children: [
                    for (final m in searcher.results.entries) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          capitalize(m.key.meaning),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      for (final l in m.value.entries)
                        for (final e in l.value)
                          ColumnTile(
                            Text(
                              capitalize(e.forms[0].plain),
                              style: TextStyle(fontSize: 16),
                            ),
                            trailing: Text(
                              capitalize(l.key),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                            leadingSpace: false,
                            onTap: () {
                              setState(() {
                                language = l.key;
                                entry = e;
                              });
                              openPage(1);
                            },
                          ),
                      Divider(height: 0),
                    ],
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Text(
                        searcher.executing
                            ? 'Searching...'
                            : searcher.done
                                ? 'End of results.'
                                : 'Start typing above to see results.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                    if (EditorStore.language != null)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: ElevatedButton.icon(
                          onPressed: openEditor,
                          icon: Icon(Icons.add_outlined),
                          label: Text('Add New Entry'),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          if (entry == null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Select entry on the left page.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.black54,
                  fontSize: 16,
                  fontStyle: FontStyle.italic,
                ),
              ),
            )
          else
            EntryDisplay(
              entry!,
              language: language,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.black,
                ),
                onPressed: () => openPage(0),
              ),
              trailing: IconButton(
                onPressed: () => setState(() {
                  useScholar = !useScholar;
                }),
                icon: Icon(
                  Icons.school_outlined,
                  color: useScholar ? Colors.blue : Colors.black,
                ),
                tooltip: 'Toggle Scholar Mode',
              ),
              bottom: language != EditorStore.language
                  ? null
                  : Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ElevatedButton.icon(
                        onPressed: () => openEditor(entry: entry),
                        icon: Icon(Icons.edit_outlined),
                        label: Text('Edit This Entry'),
                      ),
                    ),
              scholar: useScholar,
            ),
        ],
      ),
    );
  }
}
