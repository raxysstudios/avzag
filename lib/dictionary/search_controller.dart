import 'dart:async';
import 'package:avzag/store.dart';
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
  final String filters =
      BaseStore.languages.map((e) => 'language:$e').join(' OR ');
  bool searching = false;
  bool extended = false;

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
          Duration(milliseconds: 200),
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
        .index('dictionary')
        .query(text)
        .filters(filters);
    if (!text.contains('#'))
      query = query.setRestrictSearchableAttributes([
        'term',
        'forms',
        if (extended) 'definition',
      ]);

    final result = <String, List<EntryHit>>{};
    final snap = await query.getObjects();

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
        TextField(
          controller: inputController,
          decoration: InputDecoration(
            isDense: true,
            border: InputBorder.none,
            labelText: "Search by terms, forms, tags...",
            prefixIcon: Icon(
              Icons.search_outlined,
              size: 24,
            ),
            suffixIcon: inputController.text.isEmpty
                ? null
                : IconButton(
                    onPressed: () {
                      inputController.clear();
                      timer.cancel();
                      search();
                    },
                    icon: Icon(Icons.clear),
                  ),
          ),
        ),
        SizedBox(
          height: 32,
          child: ListView(
            scrollDirection: Axis.horizontal,
            // padding: const EdgeInsets.all(4),
            children: [
              FilterChip(
                avatar: Icon(Icons.lightbulb_outline),
                label: Text('Definitions'),
                selected: extended,
                onSelected: (value) {
                  extended = value;
                  search();
                },
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
