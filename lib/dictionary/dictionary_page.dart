import 'package:avzag/dictionary/editor_controller.dart';
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
  Future loadEntry(EntryHit hit) async {
    final editor = context.read<EditorController<Entry>>();
    if (editor.editing) {
      if (editor.id == hit.entryID) {
        openEntry(
          editor.object!,
          resume: true,
        );
        return;
      }
      if (await showDangerDialog(
        context,
        'Discard edits?',
        confirmText: 'Discard',
        rejectText: 'Edit',
      )) {
        editor.stopEditing();
      } else {
        return;
      }
    }
    final snapshot = await showLoadingDialog(
      context,
      FirebaseFirestore.instance
          .doc('dictionary/${hit.entryID}')
          .withConverter(
            fromFirestore: (snapshot, _) => Entry.fromJson(snapshot.data()!),
            toFirestore: (Entry object, _) => object.toJson(),
          )
          .get(),
    );
    if (snapshot?.exists ?? false) {
      editor.prepareId(hit.entryID);
      await openEntry(
        snapshot!.data()!,
        id: snapshot.id,
      );
    }
  }

  Future openEntry(
    Entry entry, {
    String? id,
    bool resume = false,
  }) async {
    final editor = context.read<EditorController<Entry>>();
    final media = MediaQuery.of(context);
    final sheetSize =
        1 - (kToolbarHeight + media.padding.top) / media.size.height;
    final done = await showModalBottomSheet<bool>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) {
        return DraggableScrollableSheet(
          minChildSize: .5,
          maxChildSize: sheetSize,
          initialChildSize: resume ? sheetSize : .5,
          builder: (context, scroll) {
            return Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              clipBehavior: Clip.antiAlias,
              child: ChangeNotifierProvider.value(
                value: editor,
                child: EntryPage(
                  entry,
                  scroll: scroll,
                ),
              ),
            );
          },
        );
      },
    );
    if (done ?? false) {
      showLoadingDialog(
        context,
        Future.delayed(
          const Duration(milliseconds: 500),
          () => context.read<EditorController<Entry>>().stopEditing(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDraver(title: 'dictionary'),
      floatingActionButton: Builder(
        builder: (context) {
          final language = GlobalStore.editing;
          if (language == null) return const SizedBox();
          final editor = context.watch<EditorController<Entry>>();
          if (editor.editing) {
            return FloatingActionButton.extended(
              onPressed: () => openEntry(
                editor.object!,
                resume: true,
              ),
              icon: const Icon(Icons.open_in_full_outlined),
              label: const Text('Resume'),
            );
          }
          return FloatingActionButton.extended(
            onPressed: () => openEntry(
              editor.startEditing(
                Entry(
                  forms: [],
                  uses: [],
                  language: language,
                ),
              ),
              resume: true,
            ),
            icon: const Icon(Icons.add_outlined),
            label: const Text('New'),
          );
        },
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
              onTap: loadEntry,
            ),
          ),
        ],
      ),
    );
  }
}
