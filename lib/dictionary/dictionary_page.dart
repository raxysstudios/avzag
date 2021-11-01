import 'package:avzag/dictionary/search_controller.dart';
import 'package:avzag/dictionary/search_results_sliver.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/widgets/danger_dialog.dart';
import 'package:avzag/widgets/editor_utils.dart';
import 'package:avzag/widgets/loading_dialog.dart';
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
  EntryHit? hit;
  var isEditing = false;

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
              ? isEditing
                  ? FloatingActionButton.extended(
                      onPressed: () => openEntry(true),
                      icon: const Icon(Icons.edit_outlined),
                      label: const Text('Resume'),
                    )
                  : FloatingActionButton.extended(
                      onPressed: () {
                        setState(() {
                          entry = Entry(
                            forms: [],
                            uses: [],
                            language: EditorStore.language!,
                          );
                          hit = null;
                          isEditing = true;
                        });
                        openEntry(true);
                      },
                      icon: const Icon(Icons.add_outlined),
                      label: const Text('New'),
                    )
              : null,
          body: CustomScrollView(
            slivers: [
              const SliverAppBar(
                pinned: true,
                snap: true,
                floating: true,
                forceElevated: true,
                title: Text('Dictionary'),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(64),
                  child: SearchToolbar(),
                ),
              ),
              if (EditorStore.isAdmin)
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      Consumer<SearchController>(
                        builder: (context, search, _) {
                          return SwitchListTile(
                            value: search.pendingOnly,
                            onChanged: (v) => search.pendingOnly = v,
                            title: const Text('Filter pending reviews'),
                            secondary:
                                const Icon(Icons.pending_actions_outlined),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              SliverPadding(
                padding: const EdgeInsets.only(bottom: 76),
                sliver: SearchResultsSliver(
                  context.watch<SearchController>(),
                  onTap: loadEntry,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future loadEntry(EntryHit hit) async {
    if (isEditing) {
      if (this.hit?.entryID == hit.entryID) {
        return openEntry(true);
      }
      if (await showDangerDialog(
        context,
        'Discard edits?',
        confirmText: 'Discard',
        rejectText: 'Edit',
      )) {
        setState(() {
          isEditing = false;
        });
      } else {
        return;
      }
    }
    final entry = await showLoadingDialog(
      context,
      FirebaseFirestore.instance
          .doc('dictionary/${hit.entryID}')
          .withConverter(
            fromFirestore: (snapshot, _) => Entry.fromJson(snapshot.data()!),
            toFirestore: (Entry object, _) => object.toJson(),
          )
          .get()
          .then((s) => s.data()),
    );
    if (entry != null) {
      setState(() {
        isEditing = false;
        this.entry = entry;
        this.hit = hit;
      });
      openEntry();
    }
  }

  Future openEntry([bool resume = false]) async {
    if (entry == null) return;
    final media = MediaQuery.of(context);
    final sheetSize =
        1 - (kToolbarHeight + media.padding.top) / media.size.height;

    final sourceEntry = entry!.contribution == null
        ? null
        : await showLoadingDialog(
            context,
            FirebaseFirestore.instance
                .doc('dictionary/${entry!.contribution!.overwriteId}')
                .withConverter(
                  fromFirestore: (snapshot, _) =>
                      Entry.fromJson(snapshot.data()!),
                  toFirestore: (Entry object, _) => object.toJson(),
                )
                .get()
                .then((s) => s.data()),
          );

    final done = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          minChildSize: .5,
          maxChildSize: sheetSize,
          initialChildSize: resume ? sheetSize : .5,
          expand: false,
          builder: (context, scroll) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: EntryPage(
                entry!,
                hit: hit,
                sourceEntry: sourceEntry,
                editor: sourceEntry == null && isEditing
                    ? getEditor(setState)
                    : null,
                scroll: scroll,
              ),
            );
          },
        );
      },
    );
    if (sourceEntry != null) {
      setState(() {
        isEditing = false;
        entry = null;
        hit = null;
      });
    } else if (done != null) {
      setState(() {
        isEditing = !done;
        if (done) {
          entry = null;
          hit = null;
        }
      });
      if (!done) openEntry(true);
    }
  }
}
