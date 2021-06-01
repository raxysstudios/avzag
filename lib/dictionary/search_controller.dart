import 'package:avzag/dictionary/models.dart';
import 'package:avzag/dictionary/searcher.dart';
import 'package:avzag/dictionary/store.dart';
import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/home/language_tile.dart';
import 'package:avzag/home/models.dart';
import 'package:avzag/home/store.dart';
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

  Language? language;
  SearchPreset? preset;

  Iterable<Language> get lngs {
    return dictionaries.keys.map(
      (n) => languages.singleWhere(
        (l) => l.name == n,
      ),
    );
  }

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
        widget.searcher.search(language?.name ?? '', inputController.text);
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
          IconButton(
            onPressed: () => setState(
              () {
                if (preset == null) {
                  inputController.clear();
                  preset = presets[0];
                } else
                  preset = null;
                search();
              },
            ),
            icon: Icon(
              preset == null
                  ? Icons.library_books_outlined
                  : Icons.search_outlined,
            ),
          ),
          ...preset == null
              ? [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                      ),
                      child: TextField(
                        controller: inputController,
                        decoration: InputDecoration(
                          labelText: language == null
                              ? "Search in English"
                              : "Search in " +
                                  capitalize(
                                    language!.name,
                                  ),
                          suffixIcon: IconButton(
                            onPressed: () => inputController.clear(),
                            icon: Icon(Icons.clear),
                          ),
                        ),
                      ),
                    ),
                  ),
                  PopupMenuButton<Language>(
                    icon: language == null
                        ? Icon(Icons.lightbulb_outlined)
                        : LanguageAvatar(language!),
                    onSelected: (l) => setState(() {
                      language = l.name == "NO" ? null : l;
                      inputController.clear();
                      search();
                    }),
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: Language(name: "NO"),
                          child: ListTile(
                            leading: Icon(
                              Icons.lightbulb_outlined,
                            ),
                            title: Text('English'),
                            selected: language == null,
                          ),
                        ),
                        PopupMenuDivider(),
                        ...lngs.map((l) {
                          return PopupMenuItem(
                            value: l,
                            child: LanguageTile(
                              l,
                              selected: language == l,
                            ),
                          );
                        })
                      ];
                    },
                  ),
                ]
              : [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        top: 11,
                        left: 4,
                        right: 12,
                      ),
                      child: DropdownButtonFormField<SearchPreset>(
                        value: preset,
                        isExpanded: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.only(
                            bottom: 11,
                          ),
                        ),
                        items: presets.map((p) {
                          return DropdownMenuItem(
                            value: p,
                            child: Text(capitalize(p.title)),
                          );
                        }).toList(),
                        onChanged: (p) => setState(() {
                          preset = p;
                          search();
                        }),
                      ),
                    ),
                  )
                ],
        ],
      ),
    );
  }
}
