import 'package:avzag/home/language.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/store.dart';
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
      drawer: NavDraver(title: 'home'),
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
          ElevatedButton.icon(
            onPressed: () async {
              var prefs = await SharedPreferences.getInstance();
              await prefs.setStringList(
                'languages',
                selected.toList(),
              );
              await BaseStore.load(context);
            },
            icon: Icon(Icons.cloud_download_outlined),
            label: Text('Download Selected'),
          ),
          Divider(height: 0),
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
