import 'dart:async';

import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/widgets/language_avatar.dart';
import 'package:avzag/shared/widgets/options_button.dart';
import 'package:avzag/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../search_controller.dart';

class SearchToolbar extends StatefulWidget {
  const SearchToolbar({Key? key}) : super(key: key);

  @override
  SearchToolbarState createState() => SearchToolbarState();
}

class SearchToolbarState extends State<SearchToolbar> {
  final inputController = TextEditingController();
  Timer timer = Timer(Duration.zero, () {});
  String lastText = '';

  @override
  void initState() {
    super.initState();
    inputController.addListener(() {
      if (lastText == inputController.text) return;
      setState(() {
        lastText = inputController.text;
      });
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

  void search() =>
      context.read<SearchController>().updateQuery(inputController.text);

  void setLanguage(String language) {
    context.read<SearchController>().language = language;
    inputController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          OptionsButton(
            [
              OptionItem.simple(
                Icons.language_outlined,
                GlobalStore.languages.length == 1 ? 'English' : 'Multilingual',
                onTap: () => setLanguage(''),
              ),
              OptionItem.simple(
                Icons.layers_outlined,
                'Cross-lingual',
                onTap: () => setLanguage('_'),
              ),
              OptionItem.divider(),
              for (final l in GlobalStore.languages.keys)
                OptionItem.tile(
                  Transform.scale(
                    scale: 1.25,
                    child: LanguageAvatar(
                      l,
                      radius: 12,
                    ),
                  ),
                  Text(
                    l.titled,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  onTap: () => setLanguage(l),
                )
            ],
            icon: Builder(builder: (context) {
              if (search.language.isEmpty) {
                return const Icon(Icons.language_outlined);
              }
              if (search.language == '_') {
                return const Icon(Icons.layers_outlined);
              }
              return LanguageAvatar(search.language);
            }),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 4),
              child: Builder(
                builder: (context) {
                  var label = 'Search ';
                  label += search.monolingual
                      ? 'forms in ${search.language.titled}'
                      : '${search.language.isEmpty ? 'over' : 'across'} the languages';
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
          if (inputController.text.isNotEmpty)
            IconButton(
              onPressed: inputController.clear,
              icon: const Icon(Icons.clear_outlined),
            ),
        ],
      ),
    );
  }
}
