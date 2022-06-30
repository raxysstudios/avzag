import 'package:auto_route/auto_route.dart';
import 'package:avzag/modules/dictionary/widgets/entry_group.dart';
import 'package:avzag/modules/navigation/screens/navigation.dart';
import 'package:avzag/modules/navigation/services/router.gr.dart';
import 'package:avzag/shared/widgets/caption.dart';
import 'package:avzag/shared/widgets/rounded_menu_button.dart';
import 'package:avzag/store.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import '../models/entry.dart';
import '../models/word.dart';
import '../search_controller.dart';
import '../services/sheets.dart';
import '../widgets/search_toolbar.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({Key? key}) : super(key: key);

  @override
  State<DictionaryScreen> createState() => DictionaryScreenState();
}

class DictionaryScreenState extends State<DictionaryScreen> {
  Word? editing;

  final paging = PagingController<int, String>(
    firstPageKey: 0,
  );
  late final search = SearchController(
    GlobalStore.languages.keys,
    algolia.index('dictionary'),
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

  void edit([Word? word]) {
    setState(() {
      if (word == null) {
        editing ??= Word(
          headword: '',
          uses: [],
          language: EditorStore.language!,
          tags: [],
          forms: [],
        );
      } else {
        editing = Word.fromJson(word.toJson(), word.id);
      }
    });
    editWord(
      context,
      editing!,
      () => setState(() {
        editing = null;
      }),
    );
  }

  void open(Entry entry) {
    if (entry.unverified &&
        EditorStore.admin &&
        EditorStore.language == entry.language) {
      diffWords(context, entry.entryID);
      return;
    }
    context.pushRoute(WordLoaderRoute(id: entry.entryID));
    // openWord(
    //   context,
    //   entry.entryID,
    //   editing == null &&
    //           entry.language == EditorStore.language &&
    //           (EditorStore.admin || !entry.unverified)
    //       ? edit
    //       : null,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: search,
      builder: (context, _) {
        return Scaffold(
          drawer: const NavigationScreen(),
          floatingActionButton: EditorStore.editor
              ? FloatingActionButton(
                  onPressed: edit,
                  tooltip: editing == null ? 'New' : 'Resume',
                  child: Icon(
                    editing == null ? Icons.add_rounded : Icons.edit_rounded,
                  ),
                )
              : null,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: const RoundedDrawerButton(),
                title: const Text('Dictionary'),
                actions: [
                  if (EditorStore.admin)
                    IconButton(
                      onPressed: () => setState(() {
                        search.unverified = !search.unverified;
                        search.updateQuery();
                      }),
                      icon: Icon(
                        Icons.unpublished_rounded,
                        color: search.unverified
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      tooltip: 'Unverified',
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
              PagedSliverList(
                pagingController: paging,
                builderDelegate: PagedChildBuilderDelegate<String>(
                  itemBuilder: (context, id, _) {
                    return EntryGroup(
                      search.getHits(id),
                      onTap: open,
                      showLanguage: GlobalStore.languages.length > 1 &&
                          !search.monolingual,
                    );
                  },
                  noItemsFoundIndicatorBuilder: _endCaption,
                  noMoreItemsIndicatorBuilder: _endCaption,
                ),
              ),
              const SliverPadding(
                padding: EdgeInsets.only(bottom: 76),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _endCaption(BuildContext context) {
    return Caption(
      search.monolingual
          ? 'End of the results'
          : 'Showing the first 50 entries',
      icon: Icons.done_all_rounded,
    );
  }
}
