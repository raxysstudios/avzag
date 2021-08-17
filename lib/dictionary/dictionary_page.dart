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
    const radius = BorderRadius.only(
      topLeft: Radius.circular(16),
      topRight: Radius.circular(16),
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
        maxHeight: MediaQuery.of(context).size.height,
        minHeight: kToolbarHeight + 16,
        panel: entry == null ? SizedBox() : null,
        renderPanelSheet: entry != null,
        color: Theme.of(context).scaffoldBackgroundColor,
        // header: hit == null
        //     ? null
        //     : AppBar(
        //         leading: IconButton(
        //           onPressed: () => Navigator.maybePop(context),
        //           icon: Icon(
        //             editing ? Icons.close_outlined : Icons.arrow_back_outlined,
        //           ),
        //         ),
        //         title: PageTitle(
        //           title: editing ? 'Entry editor' : hit!.headword,
        //           subtitle: hit!.language,
        //         ),
        //         actions: [
        //           LanguageFlag(
        //             hit!.language,
        //             offset: Offset(-40, 4),
        //             scale: 9,
        //           ),
        //         ],
        //       ),
        borderRadius: radius,
        collapsed: Container(
          decoration: BoxDecoration(
            borderRadius: radius,
          ),
          clipBehavior: Clip.antiAlias,
          child: AppBar(
            toolbarHeight: kToolbarHeight + 16,
            primary: false,
            leading: IconButton(
              onPressed: () => Navigator.maybePop(context),
              icon: Icon(
                editing ? Icons.close_outlined : Icons.arrow_back_outlined,
              ),
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
          ),
        ),
        panelBuilder: (scrollController) {
          return EntryPage(
            entry!,
            hit!,
            scrollController: scrollController,
            key: ValueKey(hit!.entryID),
          );
        },
        onPanelOpened: () => setState(() {}),
        onPanelClosed: () => setState(() {}),
      ),
    );
    return Scaffold(
      drawer: NavDraver(title: 'dictionary'),
      floatingActionButton: EditorStore.language == null
          ? null
          : FloatingActionButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EntryPage(
                    Entry(forms: [], uses: []),
                    EntryHit(
                      entryID: '',
                      headword: '',
                      language: EditorStore.language!,
                      term: '',
                    ),
                  ),
                ),
              ),
              child: Icon(
                Icons.add_outlined,
              ),
              tooltip: 'Add new entry',
            ),
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
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final hits = this.hits[index];
                  EntryHit? lastHit;
                  return Card(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: hits.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (context, index) {
                        final hit = hits[index];
                        final language = hit.language != lastHit?.language;
                        final divider = language && lastHit != null;
                        lastHit = hit;

                        final tile = HitTile(
                          hit,
                          showLanguage: language,
                          onTap: () => openEntry(hit),
                        );
                        if (divider)
                          return Column(
                            children: [
                              Divider(height: 0),
                              tile,
                            ],
                          );
                        return tile;
                      },
                    ),
                  );
                },
                childCount: hits.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
