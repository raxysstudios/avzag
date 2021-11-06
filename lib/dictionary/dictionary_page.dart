import 'package:avzag/dictionary/search_controller.dart';
import 'package:avzag/dictionary/search_results_sliver.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/widgets/span_icon.dart';
import 'package:badges/badges.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'entry.dart';
import 'entry_page.dart';
import 'search_toolbar.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'hit_tile.dart';

class DictionaryPage extends StatefulWidget {
  const DictionaryPage({Key? key}) : super(key: key);

  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  Entry? entry;

  late final SearchController search;

  @override
  void initState() {
    super.initState();
    search = SearchController(
      GlobalStore.languages.keys,
      GlobalStore.algolia.index('dictionary'),
    );
  }

  @override
  void dispose() {
    search.dispose();
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
                  ? FloatingActionButton.extended(
                      onPressed: () {
                        openEntry(
                          entry: Entry(
                            forms: [],
                            uses: [],
                            language: EditorStore.language!,
                          ),
                        );
                      },
                      icon: const Icon(Icons.add_outlined),
                      label: const Text('New'),
                    )
                  : FloatingActionButton.extended(
                      onPressed: openEntry,
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Resume'),
                    )
              : null,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                snap: true,
                floating: true,
                forceElevated: true,
                title: const Text('Dictionary'),
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight + 7),
                  child: SearchToolbar(),
                ),
                actions: [
                  if (EditorStore.isAdmin)
                    Consumer<SearchController>(
                      builder: (context, search, _) {
                        final theme = Theme.of(context).colorScheme;
                        return IconButton(
                          onPressed: () => setState(() {
                            search.pendingOnly = !search.pendingOnly;
                            search.search();
                          }),
                          icon: Icon(
                            Icons.unpublished_outlined,
                            color: search.pendingOnly ? theme.primary : null,
                          ),
                          tooltip: "Filter pending",
                        );
                      },
                    ),
                  const SizedBox(width: 4),
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 76),
                sliver: SearchResultsSliver(
                  context.watch<SearchController>(),
                  onTap: (h) => openEntry(hit: h),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future openEntry({Entry? entry, EntryHit? hit}) async {
    Entry? sourceEntry;
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
    await showModalBottomSheet<Entry>(
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
                child: EntryPage(
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

  Future<Entry?> _loadEntry(String? id) async {
    if (id == null) return null;
    return await FirebaseFirestore.instance
        .collection('dictionary')
        .doc(id)
        .withConverter(
          fromFirestore: (snapshot, _) => Entry.fromJson(
            snapshot.data()!,
            snapshot.id,
          ),
          toFirestore: (Entry object, _) => object.toJson(),
        )
        .get()
        .then((s) => s.data());
  }
}
