import 'package:avzag/widgets/column_tile.dart';
import 'search/search_controller.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'entry/entry_page.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'entry/entry_editor.dart';
import 'search/entry_hit.dart';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  EntryHitSearch? search = {};

  void viewEntry(EntryHit entry) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => EntryPage(entry),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dictionary'),
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
      body: SafeArea(
        child: Column(
          children: [
            LinearProgressIndicator(
              value: search == null ? null : 0,
              backgroundColor: Colors.transparent,
            ),
            SearchController(
              (s) => setState(() {
                search = s;
              }),
            ),
            if (search != null)
              Expanded(
                child: ListView(
                  children: [
                    for (final es in search!.entries) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        child: Text(
                          capitalize(es.key),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black54,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      for (final e in es.value)
                        ColumnTile(
                          Text(
                            capitalize(e.headword),
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: e.definition,
                          trailing: Text(
                            capitalize(e.language),
                            style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                            ),
                          ),
                          leadingSpace: false,
                          onTap: () => viewEntry(e),
                        ),
                      Divider(height: 0),
                    ],
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
