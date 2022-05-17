import 'package:avzag/dictionary/search_controller.dart';
import 'package:avzag/dictionary/widgets/search_results_sliver.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/shared/widgets/rounded_menu_button.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../models/entry.dart';
import '../models/word.dart';
import '../widgets/search_toolbar.dart';
import 'word.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({Key? key}) : super(key: key);

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen> {
  Word? entry;

  final paging = PagingController<int, String>(
    firstPageKey: 0,
  );
  late final search = SearchController(
    GlobalStore.languages.keys,
    GlobalStore.algolia.index('dictionary'),
    paging.refresh,
  );

  @override
  void initState() {
    super.initState();
    paging.addPageRequestListener(
      (page) async {
        final terms = await search.fetchHits(page);
        if (terms.isEmpty) {
          paging.appendLastPage([]);
        } else if (search.monolingual) {
          paging.appendPage(terms, page + 1);
        } else {
          paging.appendLastPage(terms);
        }
      },
    );
  }

  @override
  void dispose() {
    search.dispose();
    paging.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: search,
      builder: (context, _) {
        return Scaffold(
          drawer: const NavDraver(title: 'dictionary'),
          floatingActionButton: EditorStore.isEditing
              ? entry == null
                  ? FloatingActionButton(
                      onPressed: () {
                        openEntry(
                          entry: Word(
                            forms: [],
                            uses: [],
                            language: EditorStore.language!,
                          ),
                        );
                      },
                      tooltip: 'New',
                      child: const Icon(Icons.add_rounded),
                    )
                  : FloatingActionButton(
                      onPressed: openEntry,
                      tooltip: 'Resume',
                      child: const Icon(Icons.edit_rounded),
                    )
              : null,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: const RoundedDrawerButton(),
                title: const Text('Dictionary'),
                actions: [
                  if (EditorStore.isAdmin)
                    Consumer<SearchController>(
                      builder: (context, search, _) {
                        final theme = Theme.of(context).colorScheme;
                        return IconButton(
                          onPressed: () => setState(() {
                            search.unverified = !search.unverified;
                            search.updateQuery();
                          }),
                          icon: Icon(
                            Icons.unpublished_rounded,
                            color: search.unverified ? theme.primary : null,
                          ),
                          tooltip: 'Filter unverified',
                        );
                      },
                    ),
                  const SizedBox(width: 4),
                ],
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight + 3),
                  child: SearchToolbar(),
                ),
                pinned: true,
                snap: true,
                floating: true,
                forceElevated: true,
              ),
              ChangeNotifierProvider.value(
                value: paging,
                builder: (context, _) {
                  return SliverPadding(
                    padding: const EdgeInsets.only(bottom: 76),
                    sliver: SearchResultsSliver(
                      context.watch<SearchController>(),
                      context.watch<PagingController<int, String>>(),
                      onTap: (h) => openEntry(hit: h),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future openEntry({Word? entry, Entry? hit}) async {
    Word? sourceEntry;
    await showLoadingDialog(
      context,
      (() async {
        if (entry == null && hit != null) entry = await _loadEntry(hit.entryID);
        if (EditorStore.isAdmin) {
          sourceEntry = await _loadEntry(entry?.contribution?.overwriteId);
        }
      })(),
    );
    entry ??= this.entry;
    if (entry == null) return;

    final media = MediaQuery.of(context);
    final childSize =
        1 - (kToolbarHeight + media.padding.top) / media.size.height;
    await showModalBottomSheet<Word>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          minChildSize: childSize - .1,
          initialChildSize: childSize,
          maxChildSize: childSize,
          expand: false,
          builder: (context, scroll) {
            return Center(
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: WordScreen(
                  entry!,
                  editing: hit == null,
                  sourceEntry: sourceEntry,
                  onEdited: (e) => this.entry = e,
                  scroll: scroll,
                ),
              ),
            );
          },
        );
      },
    );
    setState(() {});
  }

  Future<Word?> _loadEntry(String? id) async {
    if (id == null) return null;
    return await FirebaseFirestore.instance
        .collection('dictionary')
        .doc(id)
        .withConverter(
          fromFirestore: (snapshot, _) => Word.fromJson(
            snapshot.data()!,
            snapshot.id,
          ),
          toFirestore: (Word object, _) => object.toJson(),
        )
        .get()
        .then((s) => s.data());
  }
}
