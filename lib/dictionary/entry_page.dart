import 'package:avzag/dictionary/meaning_tile.dart';
import 'package:avzag/store.dart';
import 'package:avzag/widgets/danger_dialog.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/widgets/tags_tile.dart';
import 'package:avzag/widgets/text_sample_tiles.dart';
import 'package:avzag/widgets/note_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'hit_tile.dart';
import 'entry.dart';

class EntryPage extends StatefulWidget {
  final Entry entry;
  final EntryHit hit;
  final ScrollController? scrollController;

  const EntryPage(
    this.entry,
    this.hit, {
    this.scrollController,
    Key? key,
  }) : super(key: key);

  @override
  _EntryPageState createState() => _EntryPageState();
}

class _EntryPageState extends State<EntryPage> {
  late Entry entry;
  bool editing = false;

  void startEditing() {
    editing = true;
    entry = Entry.fromJson(entry.toJson());
  }

  @override
  void initState() {
    super.initState();
    entry = widget.entry;
    if (entry.forms.isEmpty) startEditing();
  }

  void submit() async {
    final collection = FirebaseFirestore.instance
        .collection('languages/${EditorStore.language}/dictionary');
    final json = entry.toJson();
    final upload = widget.hit.entryID.isEmpty
        ? collection.add(json)
        : collection.doc(widget.hit.entryID).update(json);
    showLoadingDialog(
      context,
      upload.then((_) => Navigator.pop(context)),
    );
  }

  void delete() async {
    final confirm = await showDangerDialog(
      context,
      'Delete entry?',
      confirmText: 'Delete',
      rejectText: 'Keep',
    );
    if (confirm)
      showLoadingDialog(
        context,
        FirebaseFirestore.instance
            .collection('languages/${EditorStore.language}/dictionary')
            .doc(widget.hit.entryID)
            .delete()
            .then((_) => Navigator.pop(context)),
      );
  }

  List<Widget> buildTiles(BuildContext context) {
    return [
      Card(
        child: Column(
          children: [
            TextSampleTiles(
              samples: entry.forms,
              onEdited: editing
                  ? (result) => setState(() {
                        entry.forms = result!;
                      })
                  : null,
              icon: Icons.format_list_bulleted_outlined,
              name: 'form',
            ),
            TagsTile(
              entry.tags,
              onEdited: editing
                  ? (result) => setState(() {
                        entry.tags = result;
                      })
                  : null,
            ),
            NoteTile(
              entry.note,
              onEdited: editing
                  ? (result) => setState(() {
                        entry.note = result;
                      })
                  : null,
            ),
          ],
        ),
      ),
      for (final use in entry.uses)
        Card(
          child: Column(
            children: [
              MeaningTile(
                use,
                onEdited: editing
                    ? (value) => setState(() {
                          if (value == null)
                            entry.uses.remove(use);
                          else
                            entry.uses[entry.uses.indexOf(use)] = value;
                        })
                    : null,
              ),
              TagsTile(
                use.tags,
                onEdited: editing
                    ? (result) => setState(() {
                          use.tags = result;
                        })
                    : null,
              ),
              NoteTile(
                use.note,
                onEdited: editing
                    ? (result) => setState(() {
                          use.note = result;
                        })
                    : null,
              ),
              TextSampleTiles(
                samples: use.samples,
                onEdited: editing
                    ? (result) => setState(() {
                          use.samples = result;
                        })
                    : null,
                icon: Icons.bookmark_outline,
                translation: true,
              ),
            ],
          ),
        ),
      if (editing)
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextButton.icon(
                onPressed: () => MeaningTile.showEditor(
                  context: context,
                  callback: (value) {
                    if (value != null)
                      setState(() {
                        entry.uses.add(value);
                      });
                  },
                ),
                icon: Icon(Icons.add_outlined),
                label: Text('Add use'),
              ),
              if (widget.hit.entryID.isNotEmpty)
                TextButton.icon(
                  onPressed: entry.uses.isEmpty
                      ? delete
                      : () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Row(
                                children: [
                                  Icon(
                                    Icons.warning_outlined,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 8),
                                  Text('Remove all uses first.'),
                                ],
                              ),
                            ),
                          ),
                  icon: Icon(Icons.delete_outlined),
                  label: Text('Delete entry'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.red),
                    overlayColor: MaterialStateProperty.all(Colors.red.shade50),
                  ),
                ),
            ],
          ),
        )
    ];
  }

  @override
  Widget build(BuildContext context) {
    // return ListView(
    //   controller: widget.scrollController,
    //   children: buildTiles(context),
    // );
    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 64),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          buildTiles(context),
        ),
      ),
    );
    // return Scaffold(
    //   floatingActionButton: EditorStore.language != widget.hit.language
    //       ? null
    //       : editing
    //           ? FloatingActionButton(
    //               onPressed: entry.uses.isEmpty || entry.forms.isEmpty
    //                   ? () => ScaffoldMessenger.of(context).showSnackBar(
    //                         SnackBar(
    //                           content: Row(
    //                             children: [
    //                               Icon(
    //                                 Icons.warning_outlined,
    //                                 color: Colors.white,
    //                               ),
    //                               SizedBox(width: 8),
    //                               Text(
    //                                 'Must have at least one form and one use.',
    //                               ),
    //                             ],
    //                           ),
    //                         ),
    //                       )
    //                   : submit,
    //               child: Icon(Icons.publish_outlined),
    //               tooltip: 'Submit changes',
    //             )
    //           : FloatingActionButton(
    //               onPressed: () => setState(() => startEditing()),
    //               child: Icon(Icons.edit_outlined),
    //               tooltip: 'Edit entry',
    //             ),
    //   body: CustomScrollView(
    //     controller: widget.scrollController,
    //     slivers: [
    //       SliverAppBar(
    //         leading: IconButton(
    //           onPressed: () => Navigator.maybePop(context),
    //           icon: Icon(
    //             editing ? Icons.close_outlined : Icons.arrow_back_outlined,
    //           ),
    //         ),
    //         title: PageTitle(
    //           title: editing ? 'Entry editor' : widget.hit.headword,
    //           subtitle: widget.hit.language,
    //         ),
    //         actions: [
    //           LanguageFlag(
    //             widget.hit.language,
    //             offset: Offset(-40, 4),
    //             scale: 9,
    //           ),
    //         ],
    //         pinned: true,
    //         snap: true,
    //         floating: true,
    //         forceElevated: true,
    //       ),
    //       SliverPadding(
    //         padding: const EdgeInsets.only(bottom: 64),
    //         sliver: SliverList(
    //           delegate: SliverChildListDelegate(
    //             buildTiles(context),
    //           ),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
