import 'dart:async';

import 'package:avzag/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'search_controller.dart';
import 'search_mode_button.dart';

class SearchToolbar extends StatefulWidget {
  const SearchToolbar({
    Key? key,
  }) : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    final search = context.watch<SearchController>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          SearchModeButton(
            search.language,
            onSelected: (l) {
              search.language = l;
              inputController.clear();
            },
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 4),
              child: Builder(
                builder: (context) {
                  var label = 'Search ';
                  label += search.monolingual
                      ? 'forms in ${capitalize(search.language)}'
                      : (search.language.isEmpty ? 'over' : 'across') +
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
            icon: const Icon(Icons.clear_rounded),
          ),
        ],
      ),
    );
  }
}
