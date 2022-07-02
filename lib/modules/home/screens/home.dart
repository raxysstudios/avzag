import 'package:auto_route/auto_route.dart';
import 'package:avzag/models/language.dart';
import 'package:avzag/modules/home/widgets/languages_bar.dart';
import 'package:avzag/modules/navigation/services/router.gr.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/widgets/options_button.dart';
import 'package:avzag/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../widgets/language_card.dart';
import '../widgets/languages_map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _LanguageOrdering {
  final bool descending;
  final String text;
  final IconData icon;
  late final String field;

  _LanguageOrdering(
    this.icon,
    this.text, {
    String? field,
    this.descending = false,
  }) {
    this.field = field ?? text;
  }
}

class _HomeScreenState extends State<HomeScreen> {
  var catalogue = <Language>[];
  var tags = <String, String>{};
  var languages = <Language>[];
  var selected = <Language>{};

  final inputController = TextEditingController();
  var isLoading = false;
  var isMap = false;

  final orderings = [
    _LanguageOrdering(Icons.label_outlined, 'name'),
    _LanguageOrdering(
      Icons.book_outlined,
      'dictionary',
      field: 'stats.dictionary',
      descending: true,
    ),
  ];
  late var ordering = orderings.first;

  late final Future<void> loader;
  final chipsScroll = ScrollController();

  @override
  void initState() {
    super.initState();
    inputController.addListener(filterLanguages);
    load();
  }

  Future load() async {
    setState(() {
      isLoading = true;
    });
    var query = FirebaseFirestore.instance
        .collection('languages')
        .orderBy(ordering.field, descending: ordering.descending);
    if (ordering.field != 'name') query = query.orderBy('name');

    catalogue = await query
        .withConverter(
          fromFirestore: (snapshot, _) => Language.fromJson(snapshot.data()!),
          toFirestore: (__, _) => {},
        )
        .get()
        .then((r) => r.docs.map((d) => d.data()).toList());

    selected = GlobalStore.languages.keys
        .map((n) => catalogue.firstWhere((l) => l.name == n))
        .toSet();
    tags = {
      for (var l in catalogue)
        l.name: [
          l.name,
          l.endonym,
          ...l.aliases ?? [],
        ].join(' ')
    };

    isLoading = false;
    filterLanguages();
  }

  void filterLanguages() {
    if (isLoading) return;
    final query = inputController.text
        .trim()
        .toLowerCase()
        .split(' ')
        .where((s) => s.isNotEmpty);
    setState(() {
      languages
        ..clear()
        ..addAll(
          query.isEmpty
              ? catalogue
              : catalogue.where((l) {
                  final t = tags[l.name]!;
                  return query.any((q) => t.contains(q));
                }),
        );
    });
  }

  void toggleLanguage(Language language) {
    final has = selected.contains(language);
    setState(() {
      if (has) {
        selected.remove(language);
      } else {
        selected.add(language);
        SchedulerBinding.instance.addPostFrameCallback(
          (_) => chipsScroll.animateTo(
            chipsScroll.position.maxScrollExtent,
            duration: const Duration(milliseconds: 250),
            curve: Curves.ease,
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: selected.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () {
                GlobalStore.set(objects: selected);
                context.navigateTo(const RootRoute());
              },
              child: const Icon(Icons.done_all_outlined),
            ),
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        leading: IconButton(
          tooltip: isMap ? 'Show list' : 'Show map',
          icon: Icon(
            isMap ? Icons.view_list_outlined : Icons.map_outlined,
          ),
          onPressed: () => setState(() {
            isMap = !isMap;
          }),
        ),
        title: TextField(
          controller: inputController,
          decoration: const InputDecoration.collapsed(
            hintText: 'Search by names, tags, families',
          ),
        ),
        actions: [
          OptionsButton(
            [
              for (final o in orderings)
                OptionItem.simple(
                  o.icon,
                  o.text.titled,
                  onTap: () {
                    ordering = o;
                    load();
                  },
                ),
            ],
            icon: const Icon(Icons.sort_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      bottomNavigationBar: selected.isEmpty
          ? null
          : LanguagesBar(
              selected,
              onTap: (l) => setState(() {
                selected.remove(l);
              }),
              onClear: () => setState(selected.clear),
            ),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (isMap) {
            return LanguagesMap(
              onToggle: toggleLanguage,
              selected: selected,
              languages: languages,
            );
          }
          return ListView.builder(
            itemCount: languages.length,
            padding: const EdgeInsets.only(top: 12, bottom: 76),
            itemBuilder: (context, index) {
              final language = languages[index];
              return LanguageCard(
                language,
                selected: selected.contains(language),
                onTap: () => toggleLanguage(language),
              );
            },
          );
        },
      ),
    );
  }
}
