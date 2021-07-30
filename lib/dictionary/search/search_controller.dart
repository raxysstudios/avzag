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
  Timer? searchTimer;

  @override
  void initState() {
    super.initState();
    inputController.addListener(() {
      // searchTimer?.cancel();
      // searchTimer = Timer(
      //   Duration(milliseconds: 200),
      //   search,
      // );
      search();
    });
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  void search() async {
    final text = inputController.text
        .split(' ')
        .where((e) => e.isNotEmpty && e != '#')
        .join(' ');
    if (text.isEmpty) {
      widget.onSearch({});
      return;
    }
    widget.onSearch(null);

    var query = BaseStore.algolia.instance.index('dictionary').query(text);
    // .filters(BaseStore.languages.map((e) => 'language:$e').join(' OR '));
    final result = <String, List<EntryHit>>{};
    final snap = await query.getObjects();

    for (final hit in snap.hits) {
      final entry = EntryHit.fromAlgoliaHitData(hit.data);
      if (!result.containsKey(entry.term)) result[entry.term] = [];
      result[entry.term]!.add(entry);
    }
    widget.onSearch(result);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: TextField(
        controller: inputController,
        decoration: InputDecoration(
          labelText: "Search by meaning, forms, tag...",
          prefixIcon: Icon(Icons.search_outlined),
          suffixIcon: inputController.text.isEmpty
              ? null
              : IconButton(
                  onPressed: () => inputController.clear(),
                  icon: Icon(Icons.clear),
                ),
        ),
      ),
    );
  }
}
