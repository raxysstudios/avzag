import 'dart:async';

import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/widgets/language_avatar.dart';
import 'package:avzag/shared/widgets/options_button.dart';
import 'package:avzag/store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/search_controller.dart';

class SearchToolbar extends StatefulWidget {
  const SearchToolbar({Key? key}) : super(key: key);

  @override
  SearchToolbarState createState() => SearchToolbarState();
}

class SearchToolbarState extends State<SearchToolbar> {
  final _input = TextEditingController();
  Timer timer = Timer(Duration.zero, () {});
  String lastText = '';

  @override
  void initState() {
    super.initState();
    _input.addListener(() {
      if (lastText == _input.text) return;
      setState(() {
        lastText = _input.text;
      });
      timer.cancel();
      if (_input.text.isEmpty) {
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
    _input.dispose();
    super.dispose();
  }

  void search() => context.read<SearchController>().query(_input.text);

  void setLanguage(String language) {
    context.read<SearchController>().setLanguage(language);
    _input.clear();
  }

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchController>();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(width: 4),
        if (GlobalStore.languages.length == 1)
          LanguageAvatar(GlobalStore.languages.keys.first)
        else
          OptionsButton(
            [
              OptionItem.simple(
                Icons.language_outlined,
                'Global',
                onTap: () => setLanguage(''),
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
                ),
            ],
            tooltip: 'Search mode',
            icon: Builder(
              builder: (context) {
                if (search.language.isEmpty) {
                  return const Icon(Icons.language_outlined);
                }
                if (search.language == '_') {
                  return const Icon(Icons.layers_outlined);
                }
                return LanguageAvatar(search.language);
              },
            ),
          ),
        const SizedBox(width: 20),
        Expanded(
          child: Builder(
            builder: (context) {
              var label = 'Search ';
              label += search.global
                  ? 'forms in ${search.language.titled}'
                  : '${search.language.isEmpty ? 'over' : 'across'} the languages';
              return TextField(
                controller: _input,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: label,
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 4),
        if (_input.text.isNotEmpty)
          IconButton(
            onPressed: _input.clear,
            icon: const Icon(Icons.clear_outlined),
          ),
        const SizedBox(width: 4),
      ],
    );
  }
}
