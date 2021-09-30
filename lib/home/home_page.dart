import 'package:avzag/home/language.dart';
import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/utils.dart';
import 'package:avzag/widgets/loading_card.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/widgets/snackbar_manager.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'language_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late final Map<String, String> tags;
  final inputController = TextEditingController();
  final List<Language> catalogue = [];
  final List<Language> selected = [];
  final List<Language> languages = [];

  late final Future<void> loader;

  @override
  void initState() {
    super.initState();
    loader = FirebaseFirestore.instance
        .collection('languages')
        .orderBy('name')
        .where('name')
        .withConverter(
          fromFirestore: (snapshot, _) => Language.fromJson(
            snapshot.data()!,
            snapshot.id,
          ),
          toFirestore: (Language language, _) => language.toJson(),
        )
        .get()
        .then(
      (r) {
        catalogue.addAll(r.docs.map((d) => d.data()).toList());
        selected.addAll(
          GlobalStore.languages.keys.map(
            (n) => catalogue.firstWhere((l) => l.name == n),
          ),
        );
        tags = {
          for (var l in catalogue)
            l.name: [
              l.name,
              ...l.family ?? [],
              ...l.tags ?? [],
            ].join(' ')
        };
        inputController.addListener(filterLanguages);
        filterLanguages();
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  void filterLanguages() {
    final query =
        inputController.text.trim().split(' ').where((s) => s.isNotEmpty);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          if (selected.isEmpty) {
            return showSnackbar(
              context,
              text: 'Select at least one language.',
            );
          }
          showLoadingDialog(
            context,
            GlobalStore.load(
              selected.map((s) => s.name).toList(),
            ).then(
              (_) => navigate(context, null),
            ),
          );
        },
        icon: const Icon(Icons.check_outlined),
        label: const Text('Continue'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: FutureBuilder(
        future: loader,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const LoadingCard();
          }
          return CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                snap: true,
                floating: true,
                forceElevated: true,
                automaticallyImplyLeading: false,
                titleSpacing: 0,
                centerTitle: true,
                foregroundColor: Theme.of(context).colorScheme.onSurface,
                backgroundColor: Theme.of(context).colorScheme.surface,
                title: selected.isEmpty
                    ? Text(
                        'Select languages below',
                        style: Theme.of(context).textTheme.bodyText1,
                      )
                    : SizedBox(
                        height: 64,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.only(right: 2),
                          children: [
                            IconButton(
                              onPressed: () => setState(() {
                                selected.clear();
                              }),
                              icon: const Icon(Icons.clear_outlined),
                              tooltip: 'Unselect all',
                            ),
                            const SizedBox(width: 18),
                            for (final language in selected) ...[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 2),
                                child: InputChip(
                                  avatar: LanguageAvatar(
                                    language.flag,
                                    radius: 12,
                                  ),
                                  label: Text(
                                    capitalize(language.name),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  onPressed: () => setState(() {
                                    selected.remove(language);
                                  }),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(59),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Toggle map',
                        icon: const Icon(Icons.map_outlined),
                        onPressed: () => showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('The map comes soon'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20, right: 8),
                          child: TextField(
                            controller: inputController,
                            decoration: const InputDecoration(
                              border: InputBorder.none,
                              labelText: "Search by names, tags, families",
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: inputController.text.isEmpty
                            ? null
                            : inputController.clear,
                        icon: const Icon(Icons.clear_outlined),
                      ),
                    ],
                  ),
                ),
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 76),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final language = languages[index];
                      final selected = this.selected.contains(language);
                      return LanguageCard(
                        language,
                        selected: selected,
                        onTap: () => setState(
                          () => selected
                              ? this.selected.remove(language)
                              : this.selected.add(language),
                        ),
                      );
                    },
                    childCount: languages.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
