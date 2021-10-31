import 'package:avzag/dictionary/editor_button.dart';
import 'package:avzag/dictionary/search_controller.dart';
import 'package:avzag/dictionary/search_results_sliver.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/widgets/danger_dialog.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/widgets/page_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';

import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'entry.dart';
import 'entry_sliver.dart';
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
  final panelController = PanelController();

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
        panelController.open();
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
      setState(() {
        this.entry = entry;
        this.hit = hit;
      });
      panelController.open();
    }
  }

  @override
  Widget build(BuildContext context) {
    final safePadding = MediaQuery.of(context).padding.top;
    final controller = context.watch<SearchController>();
    return Scaffold(
      drawer: const NavDraver(title: 'dictionary'),
      floatingActionButton: EditorButton(
        entry,
        hit: hit,
        editing: editing,
        collapsed: collapsed,
        onStart: (entry, [hit]) {
          setState(() {
            this.entry = entry;
            this.hit = hit;
            editing = true;
            collapsed = false;
          });
          panelController.open();
        },
        onEnd: () {
          setState(() {
            entry = null;
            hit = null;
            editing = false;
            collapsed = true;
          });
          panelController.close();
        },
      ),
      body: SlidingUpPanel(
        controller: panelController,
        backdropEnabled: true,
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
            if (GlobalStore.editing != null)
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    SwitchListTile(
                      value: controller.pendingOnly,
                      onChanged: (v) {
                        controller.pendingOnly = v;
                      },
                      title: const Text('Filter pending reviews'),
                      secondary: const Icon(Icons.pending_actions_outlined),
                    ),
                  ],
                ),
              ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 76),
              sliver: SearchResultsSliver(
                onTap: openEntry,
              ),
            ),
          ],
        ),
        maxHeight: MediaQuery.of(context).size.height - kToolbarHeight,
        minHeight: editing ? kToolbarHeight + safePadding : 0,
        renderPanelSheet: false,
        panelBuilder: (controller) {
          if (entry == null) return const SizedBox();
          return Padding(
            padding: EdgeInsets.only(top: safePadding),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                boxShadow: kElevationToShadow[4],
              ),
              clipBehavior: Clip.antiAlias,
              child: CustomScrollView(
                controller: controller,
                slivers: [
                  SliverAppBar(
                    primary: false,
                    leading: Builder(
                      builder: (context) {
                        if (collapsed) {
                          return IconButton(
                            onPressed: panelController.open,
                            icon: const Icon(Icons.expand_less_outlined),
                          );
                        }
                        return IconButton(
                          onPressed: panelController.close,
                          icon: const Icon(Icons.expand_more_outlined),
                        );
                      },
                    ),
                    title: PageTitle(
                      title: editing ? 'Entry editor' : hit!.headword,
                      subtitle: editing ? GlobalStore.editing : hit!.language,
                    ),
                    actions: [
                      Opacity(
                        opacity: 0.4,
                        child: LanguageFlag(
                          GlobalStore
                              .languages[editing
                                  ? GlobalStore.editing
                                  : hit!.language]!
                              .flag,
                          offset: const Offset(-40, 4),
                          scale: 9,
                        ),
                      ),
                    ],
                    floating: true,
                    pinned: true,
                    forceElevated: true,
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.only(bottom: 76),
                    sliver: EntrySliver(
                      entry!,
                      onEdited:
                          editing ? (e) => setState(() => entry = e) : null,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        onPanelOpened: () {
          FocusScope.of(context).unfocus();
          setState(() {
            collapsed = false;
          });
        },
        onPanelClosed: () => setState(() {
          collapsed = true;
          if (!editing) {
            entry = null;
            hit = null;
          }
        }),
      ),
    );
  }
}
