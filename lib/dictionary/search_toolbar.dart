import 'dart:async';
import 'search_mode_button.dart';
import 'search_results.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'hit_tile.dart';

class SearchToolbar extends StatefulWidget {
  final ValueSetter<SearchResults> onSearch;

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
  bool searching = false;
  String language = '';
  String lastText = '';

  bool get monolingual => language.isNotEmpty && language != '_';

  @override
  void initState() {
    super.initState();
    inputController.addListener(() {
      if (lastText == inputController.text) return;
      lastText = inputController.text;
      timer.cancel();
      if (inputController.text.isEmpty) {
        search();
      } else {
        timer = Timer(
          const Duration(milliseconds: 300),
          search,
        );
      }
    });
    Timer(
      const Duration(milliseconds: 300),
      search,
    );
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
      searching = true;
    });
    widget.onSearch(SearchResults());

    final parsed = parseQuery(inputController.text);
    final languages = generateFilter(
      monolingual ? [language] : GlobalStore.languages.keys,
      'language',
    );
    var query = GlobalStore.algolia.instance
        .index('dictionary')
        .query(parsed[0])
        .filters(
          parsed[1].isEmpty ? languages : '${parsed[1]} AND ($languages)',
        );
    if (monolingual) query = query.setRestrictSearchableAttributes(['forms']);

    final hits = await query.getObjects().then(
      (snapshot) async {
        if (language != '_') return snapshot.hits;
        final terms = generateFilter(
          snapshot.hits.map((hit) => hit.data['term']),
          'term',
        );
        final original = {
          for (final hit in snapshot.hits) hit.objectID: hit,
        };
        return await GlobalStore.algolia.instance
            .index('dictionary')
            .filters('($languages) AND ($terms)')
            .getObjects()
            .then((s) => s.hits.map((h) => original[h.objectID] ?? h))
            .onError((error, stackTrace) => []);
      },
    ).then((s) => s.map((h) => EntryHit.fromAlgoliaHit(h)).toList());

    widget.onSearch(
      SearchResults(
        hits,
        GlobalStore.languages.keys,
      ),
    );
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
                      label += monolingual
                          ? 'forms in ${capitalize(language)}'
                          : (language.isEmpty ? 'over' : 'across') +
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
