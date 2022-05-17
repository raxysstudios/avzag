import 'package:avzag/dictionary/search_controller.dart';
import 'package:avzag/dictionary/widgets/search_results_sliver.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/shared/widgets/rounded_menu_button.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../models/word.dart';
import '../services/sheets.dart';
import '../widgets/search_toolbar.dart';

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
                          elseEntry: entry,
                          onEdit: (e) => entry = e,
                          context: context,
                        );
                      },
                      tooltip: 'New',
                      child: const Icon(Icons.add_rounded),
                    )
                  : FloatingActionButton(
                      onPressed: () => openEntry(
                        elseEntry: entry,
                        onEdit: (e) => entry = e,
                        context: context,
                      ),
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
                      onTap: (h) => openEntry(
                        hit: h,
                        elseEntry: entry,
                        onEdit: (e) => entry = e,
                        context: context,
                      ),
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
}
