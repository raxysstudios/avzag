import 'dart:async';
import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/home/language_tile.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'entry_hit.dart';

class SearchController extends StatefulWidget {
  final ValueSetter<EntryHitSearch> onSearch;
  const SearchController(this.onSearch);

  @override
  SearchControllerState createState() => SearchControllerState();
}

class SearchControllerState extends State<SearchController> {
  final inputController = TextEditingController();
  Timer timer = Timer(Duration.zero, () {});
  String text = "";
  bool searching = false;
  String language = '';

  @override
  void initState() {
    super.initState();
    inputController.addListener(() {
      final text = inputController.text
          .split(' ')
          .where((e) => e.isNotEmpty && e != '#')
          .join(' ');
      if (this.text != text || text.isEmpty) {
        timer.cancel();
        setState(() {
          this.text = text;
        });
        if (text.isEmpty)
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

  String filterOr(String filter, Iterable<String> values) =>
      values.map((v) => '$filter:$v').join(' OR ');

  void search() async {
    if (text.isEmpty) {
      widget.onSearch({});
      return;
    }
    widget.onSearch({});
    setState(() {
      searching = true;
    });

    var query = BaseStore.algolia.instance
        .index(language.isEmpty ? 'dictionary' : 'dictionary_headword')
        .query(text)
        .filters(
          filterOr(
            'language',
            language.isEmpty ? BaseStore.languages : [language],
          ),
        )
        .setRestrictSearchableAttributes([
      'term',
      'forms',
      'definition',
      if (text.contains('#')) 'tags',
    ]);

    final result = <String, List<EntryHit>>{};
    final snap = await query.getObjects().then(
          (snapshot) async => language.isEmpty
              ? await BaseStore.algolia.instance
                  .index('dictionary')
                  .filters(
                    filterOr(
                      'term',
                      snapshot.hits.map((hit) => hit.data['term']),
                    ),
                  )
                  .getObjects()
              : snapshot,
        );

    for (final hit in snap.hits) {
      final entry = EntryHit.fromAlgoliaHitData(hit.data);
      if (!result.containsKey(entry.term)) result[entry.term] = [];
      result[entry.term]!.add(entry);
    }

    widget.onSearch(result);
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
                icon: language.isEmpty
                    ? Icon(Icons.auto_awesome_outlined)
                    : LanguageAvatar(HomeStore.languages[language]!),
                tooltip: 'Select search mode',
                onSelected: (l) {
                  language = l;
                  inputController.clear();
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: '',
                      child: ListTile(
                        visualDensity: const VisualDensity(
                          vertical: -4,
                          horizontal: -4,
                        ),
                        leading: Icon(Icons.auto_awesome_outlined),
                        title: Text('Multilingual'),
                        selected: language.isEmpty,
                      ),
                    ),
                    for (final l in BaseStore.languages)
                      PopupMenuItem(
                        value: l,
                        child: LanguageTile(
                          HomeStore.languages[l]!,
                          selected: language == l,
                        ),
                      ),
                  ];
                },
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20, right: 4),
                  child: TextField(
                    controller: inputController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Search by terms, forms, tags' +
                          (language.isEmpty
                              ? ''
                              : ' in ${capitalize(language)}'),
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
        ),
        LinearProgressIndicator(
          value: searching ? null : 0,
          backgroundColor: Colors.transparent,
        ),
      ],
    );
  }
}
