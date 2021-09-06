import 'dart:async';
import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'hit_tile.dart';

class SearchToolbar extends StatefulWidget {
  final ValueSetter<List<List<EntryHit>>> onSearch;
  const SearchToolbar(this.onSearch);

  @override
  SearchToolbarState createState() => SearchToolbarState();
}

class SearchToolbarState extends State<SearchToolbar> {
  final inputController = TextEditingController();
  Timer timer = Timer(Duration.zero, () {});
  String text = "";
  bool searching = false;
  bool restricted = false;
  String? language;

  bool get monolingual => language?.isNotEmpty ?? false;

  @override
  void initState() {
    super.initState();
    if (GlobalStore.languages.length == 1)
      language = GlobalStore.languages.keys.first;
    inputController.addListener(() {
      if (this.text != inputController.text) {
        timer.cancel();
        setState(() {
          this.text = inputController.text;
        });
        if (this.text.isEmpty)
          search();
        else
          timer = Timer(
            Duration(milliseconds: 300),
            search,
          );
      }
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  String generateFilter(
    Iterable<String> values, [
    filter = 'tags',
    bool and = false,
  ]) {
    final joint = and ? 'AND' : 'OR';
    final tags = values.map((v) => '$filter:$v');
    return tags.join(' $joint ');
  }

  List<String> parseQuery(String query) {
    final tags = <String>[];
    final words = <String>[];
    query.split(' ').forEach((e) {
      if (e.startsWith('#'))
        tags.add(e.substring(1));
      else
        words.add(e);
    });
    return [
      generateFilter(tags, 'tags', true),
      words.join(' '),
    ];
  }

  void search() async {
    setState(() {
      searching = text.isNotEmpty;
    });
    widget.onSearch(<List<EntryHit>>[]);
    if (!searching) return;

    final parsed = parseQuery(text);
    final languages = generateFilter(
      monolingual ? [language!] : GlobalStore.languages.keys,
      'language',
    );
    var query = (monolingual
            ? GlobalStore.algolia.instance
                .index('dictionary_headword')
                .setRestrictSearchableAttributes(['forms'])
            : GlobalStore.algolia.instance.index('dictionary'))
        .query(parsed[0])
        .filters(
          parsed[1].isEmpty ? languages : '${parsed[1]} AND ($languages)',
        );

    final snap = await query.getObjects().then(
      (snapshot) async {
        if (monolingual || !restricted) return snapshot;
        final terms = generateFilter(
          snapshot.hits.map((hit) => hit.data['term']),
          'term',
        );
        return await GlobalStore.algolia.instance
            .index('dictionary')
            .filters('($languages) AND ($terms)')
            .getObjects();
      },
    );

    final hits = snap.hits.map((h) => EntryHit.fromAlgoliaHit(h)).toList();
    if (monolingual)
      widget.onSearch([hits]);
    else {
      final groups = <String, List<EntryHit>>{};
      for (final hit in hits) {
        final key = hit.term;
        if (!groups.containsKey(key)) groups[key] = [];
        groups[key]!.add(hit);
      }
      widget.onSearch(groups.values.toList());
    }
    setState(() {
      searching = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              PopupMenuButton<String>(
                icon: language == null
                    ? Icon(Icons.language_outlined)
                    : language!.isEmpty
                        ? Icon(Icons.auto_awesome_outlined)
                        : LanguageAvatar(GlobalStore.languages[language]!.flag),
                tooltip: 'Select search mode',
                onSelected: (l) {
                  setState(() {
                    language = l == 'English' ? null : l;
                  });
                  inputController.clear();
                },
                itemBuilder: (BuildContext context) {
                  const density = const VisualDensity(
                    vertical: VisualDensity.minimumDensity,
                    horizontal: VisualDensity.minimumDensity,
                  );
                  return [
                    if (GlobalStore.languages.length > 1) ...[
                      PopupMenuItem(
                        value: 'English',
                        child: ListTile(
                          visualDensity: density,
                          leading: Icon(Icons.language_outlined),
                          title: Text('Parallel'),
                          selected: language == null,
                        ),
                      ),
                      PopupMenuItem(
                        value: '',
                        child: ListTile(
                          visualDensity: density,
                          leading: Icon(Icons.auto_awesome_outlined),
                          title: Text('Cross-lingual'),
                          selected: language?.isEmpty ?? false,
                        ),
                      ),
                      PopupMenuDivider(),
                    ],
                    for (final l in GlobalStore.languages.values)
                      PopupMenuItem(
                        value: l.name,
                        child: ListTile(
                          visualDensity: density,
                          leading: LanguageAvatar(l.flag),
                          title: Text(
                            capitalize(l.name),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          selected: language == l.name,
                        ),
                      ),
                  ];
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 4),
                  child: Builder(
                    builder: (context) {
                      var label = 'Search by ';
                      label += restricted ? 'forms ' : 'terms, forms, tags ';
                      label += monolingual
                          ? 'in ${capitalize(language!)}'
                          : (restricted ? 'between' : 'across') +
                              'across the languages';
                      return TextField(
                        controller: inputController,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          labelText: label,
                        ),
                      );
                    },
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
        ),
        LinearProgressIndicator(
          value: searching ? null : 0,
        ),
      ],
    );
  }
}
