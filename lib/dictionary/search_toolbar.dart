import 'dart:async';
import 'package:avzag/dictionary/search_mode_button.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'hit_tile.dart';

class SearchToolbar extends StatefulWidget {
  final ValueSetter<List<List<EntryHit>>> onSearch;

  const SearchToolbar(
    this.onSearch, {
    Key? key,
  }) : super(key: key);

  @override
  SearchToolbarState createState() => SearchToolbarState();
}

class SearchToolbarState extends State<SearchToolbar> {
  final inputController = TextEditingController();
  Timer timer = Timer(Duration.zero, () {});
  String text = "";
  bool searching = false;
  String language = '';

  bool get monolingual => language.isNotEmpty && language != '_';

  @override
  void initState() {
    super.initState();
    inputController.addListener(() {
      if (text != inputController.text) {
        timer.cancel();
        setState(() {
          text = inputController.text;
        });
        if (text.isEmpty) {
          search();
        } else {
          timer = Timer(
            const Duration(milliseconds: 300),
            search,
          );
        }
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
    final tags = values.map((v) => '$filter:"$v"');
    return tags.join(' $joint ');
  }

  List<String> parseQuery(String query) {
    final tags = <String>[];
    final words = <String>[];
    query.split(' ').forEach((e) {
      if (e.startsWith('#')) {
        tags.add(e.substring(1));
      } else {
        words.add(e);
      }
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
    if (monolingual) query = query.setRestrictSearchableAttributes(['forms']);

    final hits = await query.getObjects().then(
      (snapshot) async {
        if (monolingual) return snapshot.hits;
        final terms = generateFilter(
          snapshot.hits.map((hit) => hit.data['term']),
          'term',
        );
        return await GlobalStore.algolia.instance
            .index('dictionary')
            .filters('($languages) AND ($terms)')
            .getObjects()
            .then((s) => s.hits)
            .onError((error, stackTrace) => []);
      },
    ).then((s) => s.map((h) => EntryHit.fromAlgoliaHit(h)).toList());

    if (monolingual) {
      widget.onSearch([hits]);
    } else {
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
              SearchModeButton(
                language,
                onSelected: (l) => setState(() {
                  language = l;
                  inputController.clear();
                }),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 4),
                  child: Builder(
                    builder: (context) {
                      var label = 'Search ';
                      if (monolingual) label += 'by forms ';
                      label += monolingual
                          ? 'in ${capitalize(language)}'
                          : (language.isEmpty ? 'across' : 'between') +
                              ' the languages';
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
                icon: const Icon(Icons.clear_outlined),
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
