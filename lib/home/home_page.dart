import 'package:avzag/home/language.dart';
import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
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

  @override
  void dispose() {
    BaseStore.languages = selected.toList();
    super.dispose();
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
        automaticallyImplyLeading: false,
        titleSpacing: 4,
        title: Row(
          children: [
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('The map comes soon'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('Close'),
                      )
                    ],
                  );
                },
              ),
              icon: Icon(Icons.map_outlined),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, right: 8),
                child: TextField(
                  controller: inputController,
                  decoration: InputDecoration(
                    labelText: "Search by names, tags, families",
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed:
                  inputController.text.isEmpty ? null : inputController.clear,
              icon: Icon(Icons.clear),
            ),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: Column(
            children: [
              Divider(height: 0),
              Container(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  children: [
                    if (selected.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'Tap below to selected languages',
                            style: TextStyle(
                              color: Colors.black54,
                              fontStyle: FontStyle.italic,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      )
                    else ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 2),
                        child: InputChip(
                          avatar: Icon(Icons.cancel),
                          label: Text('Clear'),
                          onPressed: () => setState(() {
                            selected.clear();
                          }),
                        ),
                      ),
                      for (final language in selected) ...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: InputChip(
                            avatar: LanguageAvatar(
                              language,
                              radius: 12,
                            ),
                            label: Text(
                              capitalize(language),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onPressed: () => setState(() {
                              selected.remove(language);
                            }),
                          ),
                        ),
                      ],
                    ]
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade50,
      floatingActionButton: selected.isEmpty
          ? null
          : FloatingActionButton.extended(
              onPressed: () async {
                await BaseStore.load(
                  context,
                  languages: selected,
                );
                await navigate(context, null);
              },
              icon: Icon(Icons.arrow_back_outlined),
              label: Text('Continue'),
            ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 64),
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
    );
  }
}
