import 'package:avzag/home/language.dart';
import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/utils/utils.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/utils/snackbar_manager.dart';
import 'package:avzag/widgets/span_icon.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'language_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _LanguageOrdering {
  final bool descending;
  final String text;
  final IconData? icon;
  late final String field;

  _LanguageOrdering(
    this.text, {
    this.icon,
    String? field,
    this.descending = false,
  }) {
    this.field = field ?? text;
  }
}

class _HomePageState extends State<HomePage> {
  var catalogue = <Language>[];
  var tags = <String, String>{};
  var languages = <Language>[];
  var selected = <Language>[];

  final inputController = TextEditingController();
  var isLoading = false;

  final orderings = [
    _LanguageOrdering('name', icon: Icons.label_outline),
    _LanguageOrdering('family', icon: Icons.public_outlined),
    null,
    _LanguageOrdering(
      'dictionary',
      icon: Icons.book_outlined,
      field: 'stats.dictionary',
      descending: true,
    ),
  ];
  late var ordering = orderings.first!;

  late final Future<void> loader;

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
          toFirestore: (Language language, _) => language.toJson(),
        )
        .get()
        .then((r) => r.docs.map((d) => d.data()).toList());

    selected = GlobalStore.languages.keys
        .map((n) => catalogue.firstWhere((l) => l.name == n))
        .toList();
    tags = {
      for (var l in catalogue)
        l.name: [
          l.name,
          ...l.family ?? [],
          ...l.tags ?? [],
        ].join(' ')
    };

    isLoading = false;
    filterLanguages();
  }

  void filterLanguages() {
    if (isLoading) return;
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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (selected.isEmpty) {
            return showSnackbar(
              context,
              text: 'Select at least one language.',
            );
          }
          await showLoadingDialog(
            context,
            GlobalStore.load(
              selected.map((s) => s.name).toList(),
            ),
          );
          navigate(context);
        },
        child: const Icon(Icons.check_outlined),
        tooltip: 'Continue',
      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            snap: true,
            floating: true,
            forceElevated: true,
            automaticallyImplyLeading: false,
            titleSpacing: 0,
            centerTitle: true,
            title: selected.isEmpty
                ? Text(
                    'Select languages below',
                    style: Theme.of(context).textTheme.bodyText1,
                  )
                : SizedBox(
                    height: kToolbarHeight,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      children: [
                        IconButton(
                          onPressed: () => setState(() {
                            selected.clear();
                          }),
                          icon: const Icon(Icons.clear_outlined),
                          tooltip: 'Unselect all',
                        ),
                        const SizedBox(width: 18),
                        for (final language in selected)
                          Padding(
                            padding: const EdgeInsets.only(right: 4),
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
                    ),
                  ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight + 7),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
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
                        Builder(builder: (context) {
                          return Badge(
                            ignorePointer: true,
                            animationType: BadgeAnimationType.fade,
                            position: BadgePosition.topStart(),
                            badgeColor: Theme.of(context).colorScheme.primary,
                            badgeContent: SpanIcon(
                              ordering.icon!,
                              color: Theme.of(context).colorScheme.onPrimary,
                              padding: EdgeInsets.zero,
                            ),
                            child: PopupMenuButton(
                              icon: const Icon(Icons.filter_alt_outlined),
                              tooltip: 'Order by',
                              itemBuilder: (BuildContext context) {
                                return <PopupMenuEntry>[
                                  for (final ordering in orderings)
                                    if (ordering == null)
                                      const PopupMenuDivider(height: 0)
                                    else
                                      PopupMenuItem(
                                        onTap: () {
                                          this.ordering = ordering;
                                          load();
                                        },
                                        child: ListTile(
                                          leading: Icon(ordering.icon),
                                          title: Text(
                                            capitalize(ordering.text),
                                            softWrap: false,
                                            overflow: TextOverflow.fade,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                          selected: this.ordering == ordering,
                                        ),
                                      )
                                ];
                              },
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                  LinearProgressIndicator(value: isLoading ? null : 0),
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
      ),
    );
  }
}
