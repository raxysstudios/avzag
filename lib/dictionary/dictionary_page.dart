import 'package:avzag/widgets/column_tile.dart';
import 'package:avzag/dictionary/help_button.dart';
import 'search/search_controller.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'entry/entry_display.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'entry/entry_editor.dart';
import 'search/entry_hit.dart';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  bool useScholar = false;
  int page = 0;
  EntryHitSearch? search = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionaries'),
        actions: [
          HelpButton(),
          SizedBox(width: 4),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(4),
          child: LinearProgressIndicator(
            value: search == null ? null : 0,
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
                  builder: (_) => EntryEditor(),
                ),
              ),
              child: Icon(
                Icons.add_outlined,
              ),
              tooltip: 'Add new entry',
            ),
      body: Column(
        children: [
          SearchController(
            (s) => setState(() {
              search = s;
              print('###$s');
            }),
          ),
          Divider(height: 0),
          if (search != null)
            Expanded(
              child: ListView(
                children: [
                  for (final es in search!.values) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Text(
                        capitalize(es.first.meaning),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    for (final e in es)
                      ColumnTile(
                        Text(
                          capitalize(e.form),
                          style: TextStyle(fontSize: 16),
                        ),
                        trailing: Text(
                          capitalize(e.language),
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 14,
                          ),
                        ),
                        leadingSpace: false,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (_) {
                              return EntryDisplay(
                                e,
                                actions: [
                                  IconButton(
                                    onPressed: () => setState(() {
                                      useScholar = !useScholar;
                                    }),
                                    icon: Icon(
                                      Icons.school_outlined,
                                      color: useScholar
                                          ? Colors.blue
                                          : Colors.black,
                                    ),
                                    tooltip: 'Toggle Scholar Mode',
                                  ),
                                ],
                                scholar: useScholar,
                              );
                            },
                          );
                        },
                      ),
                    Divider(height: 0),
                  ],
                ],
              ),
            ),
        ],
      ),
    );
  }
}
