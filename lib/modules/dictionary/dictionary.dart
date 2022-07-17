import 'package:auto_route/auto_route.dart';
import 'package:bazur/models/entry.dart';
import 'package:bazur/models/word.dart';
import 'package:bazur/modules/dictionary/widgets/entry_group.dart';
import 'package:bazur/navigation/router.gr.dart';
import 'package:bazur/shared/modals/loading_dialog.dart';
import 'package:bazur/shared/modals/snackbar_manager.dart';
import 'package:bazur/shared/widgets/caption.dart';
import 'package:bazur/store.dart';
import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';

import 'services/search_controller.dart';
import 'services/word.dart';
import 'widgets/search_toolbar.dart';

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
    GlobalStore.languages,
    algolia.index('dictionary'),
    paging.refresh,
  );

  @override
  void initState() {
    super.initState();
    paging.addPageRequestListener(
      (page) async {
        final terms = await search.fetch(page);
        if (terms.isEmpty) {
          paging.appendLastPage([]);
        } else if (search.global) {
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
          null,
          headword: '',
          definitions: [],
          language: EditorStore.language!,
          tags: [],
          forms: [],
        );
      } else {
        editing = Word.fromJson(word.toJson(), word.id);
      }
    });
    context.pushRoute(
      WordEditorRoute(
        word: editing!,
        onDone: () => setState(() {
          editing = null;
        }),
      ),
    );
  }

  void open(Entry entry) async {
    if (entry.unverified &&
        EditorStore.admin &&
        EditorStore.language == entry.language) {
      final overwrite = await showLoadingDialog(
        context,
        loadWord(entry.entryID),
      );
      if (overwrite?.contribution == null) return showSnackbar(context);
      final base = await showLoadingDialog(
        context,
        loadWord(overwrite?.contribution!.overwriteId),
      );
      context.pushRoute(
        WordsDiffRoute(
          base: base,
          overwrite: overwrite!,
        ),
      );
    } else {
      context.pushRoute(
        WordLoaderRoute(
          id: entry.entryID,
          onEdit: editing == null &&
                  entry.language == EditorStore.language &&
                  (EditorStore.admin || !entry.unverified)
              ? edit
              : null,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: search,
      builder: (context, _) {
        return Scaffold(
          floatingActionButton: EditorStore.editor
              ? FloatingActionButton(
                  onPressed: edit,
                  tooltip: editing == null ? 'New' : 'Resume',
                  child: Icon(
                    editing == null ? Icons.add_outlined : Icons.edit_outlined,
                  ),
                )
              : null,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                leading: IconButton(
                  onPressed: () async {
                    await context.pushRoute(const HomeRoute());
                    search.setLanguage('', GlobalStore.languages);
                  },
                  tooltip: 'Home',
                  icon: const Icon(Icons.landscape_outlined),
                ),
                title: const Text('Bazur'),
                actions: [
                  IconButton(
                    onPressed: () => showSnackbar(
                      context,
                      icon: Icons.info_outlined,
                      text: 'Bookmarks are coming soon',
                    ),
                    icon: const Icon(Icons.bookmark_border_outlined),
                    tooltip: 'Bookmarks',
                  ),
                  IconButton(
                    onPressed: () => showSnackbar(
                      context,
                      icon: Icons.info_outlined,
                      text: 'History is coming soon',
                    ),
                    icon: const Icon(Icons.history_outlined),
                    tooltip: 'History',
                  ),
                  IconButton(
                    onPressed: () async {
                      await context.pushRoute(const SettingsRoute());
                      setState(() {});
                    },
                    icon: const Icon(Icons.settings_outlined),
                    tooltip: 'Settings',
                  ),
                  const SizedBox(width: 4),
                ],
                bottom: const PreferredSize(
                  preferredSize: Size.fromHeight(kToolbarHeight),
                  child: SizedBox(
                    height: kToolbarHeight,
                    child: SearchToolbar(),
                  ),
                ),
                pinned: true,
                snap: true,
                floating: true,
                forceElevated: true,
              ),
              SliverList(
                delegate: SliverChildListDelegate([
                  if (EditorStore.admin) ...[
                    SwitchListTile(
                      value: context.read<SearchController>().unverified,
                      secondary: const Icon(Icons.unpublished_outlined),
                      title: const Text('Only unverified'),
                      onChanged: (v) => setState(() {
                        search.unverified = v;
                        search.query();
                      }),
                    ),
                    const Divider(),
                  ],
                  Builder(
                    builder: (context) {
                      final snapshot =
                          context.watch<SearchController>().snapshot;
                      return Caption(
                        snapshot == null
                            ? 'Searching...'
                            : 'Found ${snapshot.nbHits} entries',
                        icon: Icons.search_outlined,
                        padding: const EdgeInsets.only(
                          right: 20,
                          top: 16,
                          bottom: 4,
                          left: 20,
                        ),
                        centered: false,
                      );
                    },
                  ),
                ]),
              ),
              PagedSliverList(
                pagingController: paging,
                builderDelegate: PagedChildBuilderDelegate<String>(
                  itemBuilder: (context, id, _) {
                    return EntryGroup(
                      search.getHits(id),
                      onTap: open,
                      showLanguage:
                          GlobalStore.languages.length > 1 && !search.global,
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
    if (context.watch<SearchController>().snapshot?.nbHits == 0) {
      return const SizedBox();
    }
    return Caption(
      search.global ? 'End of the results' : 'Showing the first 50 entries',
      icon: Icons.done_all_outlined,
      centered: false,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    );
  }
}
