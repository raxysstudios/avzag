import 'package:avzag/dictionary/concept/concept_selector.dart';
import 'package:avzag/dictionary/sample/sample.dart';
import 'package:avzag/dictionary/sample/sample_display.dart';
import 'package:avzag/dictionary/use/use.dart';
import 'package:avzag/loading_dialog.dart';
import 'package:avzag/store.dart';
import 'package:avzag/widgets/tag_selection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../concept/concept_display.dart';
import '../store.dart';
import '../sample/sample_editor.dart';
import 'entry.dart';

class EntryEditor extends StatefulWidget {
  final Entry? entry;
  EntryEditor({this.entry});

  @override
  _EntryEditorState createState() => _EntryEditorState();
}

class _EntryEditorState extends State<EntryEditor>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  late Entry entry;
  Function()? newItem;

  @override
  void initState() {
    super.initState();
    entry = widget.entry == null
        ? Entry(id: '', forms: [], uses: [])
        : Entry.fromJson(
            widget.entry!.toJson(),
            id: widget.entry!.id,
          );

    tabController = TabController(length: 3, vsync: this);
    tabController.addListener(
      () => setState(() {
        if (tabController.index == 0)
          newItem = () => selectForm(form: null);
        else if (tabController.index == 1)
          newItem = () => selectConcept(use: null);
        else
          newItem = null;
      }),
    );
    newItem = () => selectForm(form: null);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void selectConcept({Use? use}) {
    showDialog<String>(
      context: context,
      builder: (_) => ConceptSelect(),
    ).then((result) {
      if (result == null) return;
      if (use == null) {
        setState(
          () => entry.uses.add(
            Use(concept: result),
          ),
        );
      } else
        setState(() {
          use.concept = result;
        });
    });
  }

  void selectSample({Use? use, Sample? sample}) {
    showDialog<Sample>(
      context: context,
      builder: (_) {
        return SampleEditor(
          sample ?? Sample(plain: ""),
          title: sample == null ? "Add sample" : "Edit sample",
        );
      },
    ).then((result) {
      if (result == null) return;
      if (sample == null) {
        if (use != null) {
          if (use.samples == null) use.samples = [];
          setState(() => use.samples!.add(result));
        }
      } else {
        var i = use!.samples!.indexOf(sample);
        setState(() {
          use.samples![i] = result;
        });
      }
    });
  }

  void selectForm({Sample? form}) {
    showDialog<Sample>(
      context: context,
      builder: (_) {
        return SampleEditor(
          form ?? Sample(plain: ""),
          title: form == null ? "Add form" : "Edit form",
          translation: false,
        );
      },
    ).then((result) {
      if (result == null) return;
      if (form == null)
        setState(() => entry.forms.add(result));
      else {
        final i = entry.forms.indexOf(form);
        setState(() {
          entry.forms[i] = result;
        });
      }
    });
  }

  void uploadEntry() async {
    final collection = FirebaseFirestore.instance
        .collection('languages/${EditorStore.language}/dictionary');
    final dictionary = DictionaryStore.dictionaries[EditorStore.language]!;
    final json = entry.toJson();
    final future = widget.entry == null
        ? collection.add(json).then((d) {
            dictionary.add(
              Entry.fromJson(
                json,
                id: d.id,
              ),
            );
          })
        : collection.doc(entry.id).update(json).then((_) {
            final i = dictionary.indexWhere((e) => e.id == entry.id);
            if (i >= 0)
              dictionary[i] = Entry.fromJson(
                json,
                id: entry.id,
              );
          });
    await showLoadingDialog(
      context: context,
      future: future.then((_) => Navigator.pop(context)),
    );
  }

  List<Widget> buildList<T>(
    List<T> list,
    Function(T i) onTap,
    Widget Function(T i) builder, {
    List<PopupMenuItem<Function(T)>>? actions,
  }) {
    if (actions == null) actions = [];
    actions.add(PopupMenuItem(
      value: (i) => setState(() => list.remove(i)),
      child: ListTile(
        visualDensity: const VisualDensity(
          vertical: -4,
          horizontal: -4,
        ),
        leading: Icon(
          Icons.delete_outline,
          color: Colors.red,
        ),
        title: Text(
          'Delete',
          style: TextStyle(color: Colors.red),
        ),
      ),
    ));
    return [
      for (final i in list)
        ListTile(
          title: builder(i),
          onTap: () => onTap(i),
          contentPadding: const EdgeInsets.only(left: 16, right: 4),
          trailing: PopupMenuButton<Function(T)>(
            onSelected: (a) => a(i),
            itemBuilder: (BuildContext context) => actions!,
          ),
        ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Entry editor"),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.close_outlined),
        ),
        actions: [
          IconButton(
            onPressed:
                entry.forms.isEmpty || entry.uses.isEmpty ? null : uploadEntry,
            icon: Icon(Icons.cloud_upload_outlined),
          ),
          SizedBox(width: 4),
        ],
        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(text: "Forms", icon: Icon(Icons.tune_outlined)),
            Tab(text: "Uses", icon: Icon(Icons.textsms_outlined)),
            Tab(text: "Misc", icon: Icon(Icons.info_outlined)),
          ],
        ),
      ),
      floatingActionButton: newItem == null
          ? null
          : FloatingActionButton(
              onPressed: newItem,
              child: Icon(Icons.add_outlined),
            ),
      body: TabBarView(
        controller: tabController,
        children: [
          ListView(
            children: [
              if (entry.forms.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "An entry must have at least one form.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 24,
                    ),
                  ),
                ),
              ...buildList<Sample>(
                entry.forms,
                (f) => selectForm(form: f),
                (i) => SampleDisplay(i, row: true),
              )
            ],
          ),
          ListView(
            children: [
              if (entry.forms.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "An entry must use at least one concept.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 24,
                    ),
                  ),
                ),
              ...buildList<Use>(
                entry.uses,
                (u) => selectSample(use: u),
                (u) => Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: u.samples?.isEmpty ?? true ? 0 : 16,
                      ),
                      child: ConceptDisplay(
                        DictionaryStore.concepts[u.concept]!,
                        scholar: true,
                      ),
                    ),
                    if (u.samples != null)
                      ...buildList<Sample>(
                        u.samples!,
                        (s) => selectSample(use: u, sample: s),
                        (s) => SampleDisplay(s, scholar: true),
                      ),
                  ],
                ),
                actions: [
                  PopupMenuItem(
                    value: (u) => selectSample(use: u),
                    child: ListTile(
                      visualDensity: const VisualDensity(
                        vertical: -4,
                        horizontal: -4,
                      ),
                      leading: Icon(Icons.add_outlined),
                      title: Text('Add sample'),
                    ),
                  )
                ],
              ),
            ],
          ),
          ListView(
            padding: const EdgeInsets.all(8),
            children: [
              TextFormField(
                initialValue: entry.note,
                onChanged: (n) => entry.note,
                maxLines: null,
                decoration: InputDecoration(
                  filled: true,
                  labelText: "Word etymology, other notes",
                ),
              ),
              SizedBox(height: 8),
              Text("Grammar tags"),
              TagSelection(
                DictionaryStore.grammarTags,
                (t) => setState(() {
                  entry.tags = t;
                }),
                selected: entry.tags,
              ),
            ],
          )
        ],
      ),
    );
  }
}
