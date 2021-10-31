import 'package:avzag/dictionary/editor_button.dart';
import 'package:avzag/dictionary/search_controller.dart';
import 'package:avzag/dictionary/search_results_sliver.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/widgets/danger_dialog.dart';
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
  var editing = false;
  var collapsed = true;
  var pendingReviewOnly = false;
  EntryHit? hit;
  Entry? entry;

  void openEntry(EntryHit hit) async {
    if (editing) {
      if (await showDangerDialog(
        context,
        'Discard edits?',
        confirmText: 'Discard',
        rejectText: 'Edit',
      )) {
        setState(() {
          editing = false;
        });
      } else {
        return;
      }
    }

    final entry = await showLoadingDialog<Entry>(
      context,
      FirebaseFirestore.instance
          .doc('dictionary/${hit.entryID}')
          .withConverter(
            fromFirestore: (snapshot, _) => Entry.fromJson(snapshot.data()!),
            toFirestore: (Entry object, _) => object.toJson(),
          )
          .get()
          .then((snapshot) => snapshot.data()),
    );

    if (entry != null) {
      this.entry = entry;
      this.hit = hit;

      final media = MediaQuery.of(context);
      final sheetSize =
          1 - (kToolbarHeight + media.padding.top) / media.size.height;
      showModalBottomSheet(
        context: context,
        backgroundColor: Colors.transparent,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
            minChildSize: .5,
            maxChildSize: sheetSize,
            initialChildSize: .5,
            builder: (context, scroll) {
              return Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16),
                  ),
                ),
                clipBehavior: Clip.antiAlias,
                child: EntryPage(
                  entry,
                  hit: hit,
                  scroll: scroll,
                  onEdited:
                      editing ? (e) => setState(() => this.entry = e) : null,
                ),
              );
            },
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<SearchController>();
    return Scaffold(
      drawer: const NavDraver(title: 'dictionary'),
      floatingActionButton: EditorButton(
        entry,
        hit: hit,
        editing: editing,
        collapsed: collapsed,
        onStart: (entry, [hit]) => setState(() {
          this.entry = entry;
          this.hit = hit;
          editing = true;
          collapsed = false;
        }),
        onEnd: () => setState(() {
          entry = null;
          hit = null;
          editing = false;
          collapsed = true;
        }),
      ),
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
          // if (GlobalStore.editing != null)
          //   SliverList(
          //     delegate: SliverChildListDelegate(
          //       [
          //         SwitchListTile(
          //           value: controller.pendingOnly,
          //           onChanged: (v) {
          //             controller.pendingOnly = v;
          //           },
          //           title: const Text('Filter pending reviews'),
          //           secondary: const Icon(Icons.pending_actions_outlined),
          //         ),
          //       ],
          //     ),
          //   ),
          SliverPadding(
            padding: const EdgeInsets.only(bottom: 76),
            sliver: SearchResultsSliver(
              onTap: openEntry,
            ),
          ),
        ],
      ),
    );
  }
}
