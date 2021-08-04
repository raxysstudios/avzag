import 'dart:async';
import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/home/language_tile.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'entry_hit.dart';

class SearchController extends StatefulWidget {
  final ValueSetter<EntryHitSearch?> onSearch;
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
      if (this.text != text) {
        timer.cancel();
        timer = Timer(
          Duration(milliseconds: 300),
          search,
        );
        setState(() {
          this.text = text;
        });
      }
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  void clear() {
    inputController.clear();
    timer.cancel();
    search();
  }

  void search() async {
    if (text.isEmpty) {
      widget.onSearch({});
      return;
    }
    widget.onSearch(null);

    setState(() {
      searching = true;
    });

    var query = BaseStore.algolia.instance
        .index('dictionary' + (language.isEmpty ? '' : '_headword'))
        .query(text)
        .filters(language.isEmpty
            ? BaseStore.languages.map((e) => 'language:$e').join(' OR ')
            : 'language:$language');

    // TODO move restriction above
    if (!text.contains('#'))
      query = query.setRestrictSearchableAttributes([
        'term',
        'forms',
        'definition',
      ]);

    final result = <String, List<EntryHit>>{};
    final snap = await query.getObjects().then((snapshot) async {
      if (language.isEmpty || BaseStore.languages.length == 1) return snapshot;
      return await BaseStore.algolia.instance
          .index('dictionary')
          .filters(snapshot.hits.map((hit) => hit.data['term']).join(' OR '))
          .getObjects();
    });

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
                  clear();
                },
                itemBuilder: (BuildContext context) {
                  return [
                    PopupMenuItem(
                      value: '',
                      child: ListTile(
                        leading: Icon(
                          Icons.auto_awesome_outlined,
                        ),
                        title: Text('Multilingual'),
                        selected: language.isEmpty,
                      ),
                    ),
                    for (final language in BaseStore.languages)
                      PopupMenuItem(
                        value: language,
                        child: LanguageTile(
                          HomeStore.languages[language]!,
                          selected: language == language,
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
                      labelText:
                          'Search in by terms, forms, tags ${language.isEmpty ? "" : "in ${capitalize(language)}"}}...',
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: inputController.text.isEmpty ? null : clear,
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
