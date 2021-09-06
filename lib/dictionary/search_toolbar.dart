import 'dart:async';
import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart';
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
  String language = '';

  bool get monolingual => language.isNotEmpty;

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
      words.join(' '),
      generateFilter(tags, 'tags', true),
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
      monolingual ? [language] : GlobalStore.languages.keys,
      'language',
    );
    var query = GlobalStore.algolia.instance
        .index(monolingual ? 'dictionary_headword' : 'dictionary')
        .query(parsed[0])
        .filters(
          parsed[1].isEmpty ? languages : '${parsed[1]} AND ($languages)',
        );
    if (restricted) query = query.setRestrictSearchableAttributes(['forms']);

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

  void setSearch(String language, [restricted = false]) {
    setState(() {
      this.language = language;
      this.restricted = restricted;
    });
    inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Badge(
                showBadge: restricted,
                badgeColor: Theme.of(context).colorScheme.primary,
                badgeContent: Icon(
                  Icons.filter_alt_outlined,
                  size: 16,
                ),
                child: PopupMenuButton(
                  icon: language.isEmpty
                      ? Icon(Icons.language_outlined)
                      : LanguageAvatar(
                          GlobalStore.languages[language]!.flag,
                        ),
                  tooltip: 'Select search mode',
                  itemBuilder: (BuildContext context) {
                    const density = const VisualDensity(
                      vertical: VisualDensity.minimumDensity,
                      horizontal: VisualDensity.minimumDensity,
                    );
                    return [
                      if (GlobalStore.languages.length > 1)
                        PopupMenuItem(
                          child: ListTile(
                            visualDensity: density,
                            leading: Icon(Icons.auto_awesome_outlined),
                            title: Text('Multilingual'),
                            onTap: () => setSearch(''),
                            trailing: IconButton(
                              onPressed: () => setSearch('', true),
                              icon: Icon(Icons.filter_alt_outlined),
                            ),
                            selected: language.isEmpty,
                          ),
                        ),
                      for (final l in GlobalStore.languages.values)
                        PopupMenuItem(
                          child: ListTile(
                            visualDensity: density,
                            leading: LanguageAvatar(l.flag),
                            title: Text(
                              capitalize(l.name),
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            onTap: () => setSearch(l.name),
                            trailing: IconButton(
                              onPressed: () => setSearch(l.name, true),
                              icon: Icon(Icons.filter_alt_outlined),
                            ),
                            selected: language == l.name,
                          ),
                        ),
                    ];
                  },
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 4),
                  child: Builder(
                    builder: (context) {
                      var label = 'Search by ';
                      label += restricted ? 'forms ' : 'terms, forms, tags ';
                      label += monolingual
                          ? 'in ${capitalize(language)}'
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
