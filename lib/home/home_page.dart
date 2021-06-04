import 'package:avzag/home/models.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'store.dart';
import 'language_card.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final List<String> selected;
  late final Map<String, String> tags;
  final inputController = TextEditingController();
  final List<Language> languages = [];

  @override
  void initState() {
    super.initState();
    selected = List.from(BaseStore.languages);
    tags = Map.fromIterable(
      HomeStore.languages.values,
      key: (l) => l.name,
      value: (l) => [
        l.name,
        ...l.family ?? [],
        ...l.tags ?? [],
      ].join(' '),
    );
    inputController.addListener(filterLanguages);
    filterLanguages();
  }

  void filterLanguages() {
    final query =
        inputController.text.trim().split(' ').where((s) => s.isNotEmpty);
    setState(() {
      languages
        ..clear()
        ..addAll(
          query.isEmpty
              ? HomeStore.languages.values
              : HomeStore.languages.values.where((l) {
                  final t = tags[l.name]!;
                  return query.any((q) => t.contains(q));
                }),
        );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      drawer: NavDraver(title: 'Home'),
      floatingActionButton: selected.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () async {
                var prefs = await SharedPreferences.getInstance();
                await prefs.setStringList(
                  'languages',
                  selected.toList(),
                );
                await BaseStore.load(context);
              },
              child: Icon(Icons.download_outlined),
              tooltip: 'Download data',
            ),
      body: Column(
        children: [
          TextField(
            controller: inputController,
            decoration: InputDecoration(
              labelText: "Search by names, tags, families",
              prefixIcon: Icon(Icons.search_outlined),
              suffixIcon: inputController.text.isEmpty
                  ? null
                  : IconButton(
                      onPressed: () => inputController.clear(),
                      icon: Icon(Icons.clear),
                    ),
            ),
          ),
          Container(
            height: 48,
            child: selected.isEmpty
                ? Center(
                    child: Text(
                      'Selected languages appear here.',
                      style: TextStyle(
                        fontSize: 16,
                        fontStyle: FontStyle.italic,
                        color: Colors.black54,
                      ),
                    ),
                  )
                : ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      for (final l in selected)
                        Padding(
                          padding: const EdgeInsets.all(4),
                          child: InputChip(
                            label: Text(
                              capitalize(l),
                              style: TextStyle(fontSize: 16),
                            ),
                            onPressed: () => setState(
                              () => selected.remove(l),
                            ),
                          ),
                        ),
                    ],
                  ),
          ),
          Divider(height: 2),
          Expanded(
            child: ListView(
              children: [
                for (final l in languages)
                  Builder(
                    builder: (context) {
                      final contains = selected.contains(l.name);
                      return LanguageCard(
                        l,
                        selected: contains,
                        onTap: () => setState(
                          () => contains
                              ? selected.remove(l.name)
                              : selected.add(l.name),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
