import 'package:avzag/dictionary/models.dart';
import 'package:avzag/dictionary/searcher.dart';
import 'package:avzag/dictionary/store.dart';
import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/home/language_tile.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';

class SearchController extends StatefulWidget {
  final Searcher searcher;
  const SearchController(this.searcher);

  @override
  SearchControllerState createState() => SearchControllerState();
}

class SearchControllerState extends State<SearchController> {
  final inputController = TextEditingController();
  late Future<void>? loader;

  String language = '';
  SearchPreset? preset;

  @override
  void initState() {
    super.initState();
    inputController.addListener(search);
  }

  @override
  void dispose() {
    inputController.dispose();
    super.dispose();
  }

  void search() {
    setState(() {
      if (preset == null)
        widget.searcher.search(language, inputController.text);
      else
        widget.searcher.search('', preset!.query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          PopupMenuButton<String>(
            icon: Icon(Icons.library_books_outlined),
            tooltip: "Select preset",
            onSelected: (p) => setState(() {
              inputController.text = p;
              language = '';
              search();
            }),
            itemBuilder: (BuildContext context) {
              return DictionaryStore.presets.map((p) {
                return PopupMenuItem(
                  value: p.query,
                  child: ListTile(
                    visualDensity: const VisualDensity(
                      vertical: -4,
                      horizontal: -4,
                    ),
                    title: Text(capitalize(p.title)),
                    selected: p.query == inputController.text,
                  ),
                );
              }).toList();
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 4,
              ),
              child: TextField(
                controller: inputController,
                decoration: InputDecoration(
                  labelText: language.isEmpty
                      ? "Search in English"
                      : "Search in " + capitalize(language),
                  suffixIcon: inputController.text.isEmpty
                      ? null
                      : IconButton(
                          onPressed: () => inputController.clear(),
                          icon: Icon(Icons.clear),
                        ),
                ),
              ),
            ),
          ),
          PopupMenuButton<String>(
            icon: language.isEmpty
                ? Icon(Icons.language_outlined)
                : LanguageAvatar(HomeStore.languages[language]!),
            tooltip: "Select language",
            onSelected: (l) => setState(() {
              language = l;
              inputController.clear();
              search();
            }),
            itemBuilder: (BuildContext context) {
              return [
                PopupMenuItem(
                  value: '',
                  child: ListTile(
                    visualDensity: const VisualDensity(
                      vertical: -4,
                      horizontal: -4,
                    ),
                    leading: Icon(
                      Icons.language_outlined,
                    ),
                    title: Text('English'),
                    selected: language.isEmpty,
                  ),
                ),
                PopupMenuDivider(),
                ...BaseStore.languages.map((l) {
                  return PopupMenuItem(
                    value: l,
                    child: LanguageTile(
                      HomeStore.languages[l]!,
                      selected: language == l,
                    ),
                  );
                })
              ];
            },
          ),
        ],
      ),
    );
  }
}
