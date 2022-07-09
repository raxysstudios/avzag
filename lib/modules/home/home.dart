import 'package:auto_route/auto_route.dart';
import 'package:avzag/models/language.dart';
import 'package:avzag/modules/home/widgets/languages_bar.dart';
import 'package:avzag/navigation/router.gr.dart';
import 'package:avzag/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'widgets/language_card.dart';
import 'widgets/languages_map.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var catalogue = <Language>[];
  var tags = <String, String>{};
  var languages = <Language>[];
  var selected = <Language>{};

  final _input = TextEditingController();
  var loading = false;
  var map = false;
  var alpha = true;

  @override
  void initState() {
    super.initState();
    _input.addListener(filterLanguages);
    load();
  }

  Future load() async {
    setState(() {
      loading = true;
    });
    catalogue = await FirebaseFirestore.instance
        .collection('languages')
        .orderBy(
          alpha ? 'name' : 'stats.dictionary',
          descending: !alpha,
        )
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

    loading = false;
    filterLanguages();
  }

  void filterLanguages() {
    if (loading) return;
    final query =
        _input.text.trim().toLowerCase().split(' ').where((s) => s.isNotEmpty);
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

  void toggleLanguage(Language language) => setState(() {
        if (selected.contains(language)) {
          selected.remove(language);
        } else {
          selected.add(language);
        }
      });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        centerTitle: true,
        leading: IconButton(
          tooltip: map ? 'Show list' : 'Show map',
          icon: Icon(
            map ? Icons.view_list_outlined : Icons.map_outlined,
          ),
          onPressed: () => setState(() {
            map = !map;
          }),
        ),
        title: TextField(
          controller: _input,
          decoration: const InputDecoration(
            border: InputBorder.none,
            hintText: 'Search by names, tags, families',
          ),
        ),
        actions: [
          IconButton(
            onPressed: () => setState(() {
              alpha = !alpha;
              load();
            }),
            icon: Icon(
              alpha ? Icons.sort_by_alpha_outlined : Icons.sort_outlined,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
      floatingActionButton: selected.isEmpty
          ? null
          : FloatingActionButton(
              onPressed: () {
                GlobalStore.set(objects: selected);
                context.navigateTo(const RootRoute());
              },
              child: const Icon(Icons.done_all_outlined),
            ),
      bottomNavigationBar: LanguagesBar(
        selected,
        onTap: (l) => setState(() {
          selected.remove(l);
        }),
        onClear: () => setState(selected.clear),
      ),
      body: Builder(
        builder: (context) {
          if (loading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (map) {
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
