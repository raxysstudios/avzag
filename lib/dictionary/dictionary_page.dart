import 'package:avzag/dictionary/search_results_sliver.dart';
import 'package:avzag/home/language_flag.dart';
import 'package:avzag/store.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/widgets/page_title.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'entry.dart';
import 'entry_page.dart';
import 'search_controller.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:flutter/material.dart';
import 'hit_tile.dart';

class DictionaryPage extends StatefulWidget {
  @override
  _DictionaryPageState createState() => _DictionaryPageState();
}

class _DictionaryPageState extends State<DictionaryPage> {
  var hits = <List<EntryHit>>[];
  var editing = false;
  EntryHit? hit;
  Entry? entry;
  final panelController = PanelController();

  void openEntry(EntryHit hit) async {
    final entry = await showLoadingDialog<Entry>(
      context,
      FirebaseFirestore.instance
          .doc('languages/${hit.language}/dictionary/${hit.entryID}')
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
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => EntryPage(entry, hit),
    //   ),
    // );
  }

  @override
  Widget build(BuildContext context) {
    const radius = BorderRadius.vertical(
      top: Radius.circular(16),
    );
    return Scaffold(
      drawer: NavDraver(title: 'dictionary'),
      floatingActionButton: Builder(
        builder: (context) {
          if (EditorStore.language == null || panelController.isPanelOpen)
            return SizedBox();
          return FloatingActionButton(
            onPressed: () => setState(() {
              entry = Entry(forms: [], uses: []);
              hit = EntryHit(
                entryID: '',
                headword: '',
                language: EditorStore.language!,
                term: '',
              );
            }),
            child: Icon(
              Icons.add_outlined,
            ),
            tooltip: 'Add new entry',
          );
        },
      ),
      body: SlidingUpPanel(
        controller: panelController,
        backdropEnabled: true,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              pinned: true,
              snap: true,
              floating: true,
              forceElevated: true,
              title: Text('Dictionary'),
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(64),
                child: SearchController(
                  (s) => setState(() {
                    hits = s;
                  }),
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(bottom: 64),
              sliver: SearchResultsSliver(
                hits,
                onTap: openEntry,
              ),
            ),
          ],
        ),
        maxHeight: MediaQuery.of(context).size.height -
            kToolbarHeight -
            MediaQuery.of(context).padding.top,
        minHeight: kToolbarHeight,
        panel: entry == null ? SizedBox() : null,
        renderPanelSheet: entry != null,
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: radius,
        panelBuilder: (scrollController) {
          return Material(
            borderRadius: radius,
            clipBehavior: Clip.antiAlias,
            child: CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  primary: false,
                  leading: Builder(
                    builder: (context) {
                      if (panelController.isPanelOpen)
                        return IconButton(
                          onPressed: panelController.close,
                          icon: Icon(Icons.expand_more_outlined),
                        );
                      return IconButton(
                        onPressed: panelController.open,
                        icon: Icon(Icons.expand_less_outlined),
                      );
                    },
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: radius,
                  ),
                  title: PageTitle(
                    title: editing ? 'Entry editor' : hit!.headword,
                    subtitle: hit!.language,
                  ),
                  actions: [
                    LanguageFlag(
                      hit!.language,
                      offset: Offset(-40, 4),
                      scale: 9,
                    ),
                  ],
                  floating: true,
                  pinned: true,
                  forceElevated: true,
                ),
                SliverPadding(
                  padding: const EdgeInsets.only(bottom: 64),
                  sliver: EntryPage(
                    entry!,
                    hit!,
                    scrollController: scrollController,
                    key: ValueKey(hit!.entryID),
                  ),
                ),
              ],
            ),
          );
        },
        onPanelOpened: () {
          FocusScope.of(context).unfocus();
          setState(() {});
        },
        onPanelClosed: () => setState(() {}),
      ),
    );
  }
}
