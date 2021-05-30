import 'package:avzag/dictionary/concept/concept_selector.dart';
import 'package:avzag/dictionary/sample/sample.dart';
import 'package:avzag/dictionary/sample/sample_display.dart';
import 'package:avzag/dictionary/use/use.dart';
import 'package:avzag/tag_selection.dart';
import 'package:flutter/material.dart';

import '../concept/concept_display.dart';
import '../store.dart';
import '../sample/sample_editor.dart';
import 'entry.dart';

class EntryEditor extends StatefulWidget {
  EntryEditor(this.sourceEntry);
  final Entry sourceEntry;

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
    entry = Entry.fromJson(widget.sourceEntry.toJson());
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

  void selectConcept({Use? use}) async {
    final result = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text("Select concept"),
        contentPadding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 320,
            child: ConceptSelect(
              (k) => Navigator.pop(context, k),
            ),
          ),
        ],
      ),
    );
    if (result != null)
      setState(() {
        if (use == null) {
          if (entry.uses == null) entry.uses = [];
          entry.uses!.add(Use(concept: result));
        } else
          use.concept = result;
      });
  }

  void selectSample({Use? use, Sample? sample}) async {
    final result = await showDialog<Sample>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text("Fill Sample"),
        contentPadding: const EdgeInsets.all(16),
        children: [
          SampleEditor(
            sample ?? Sample(plain: ""),
            (s) => Navigator.pop(context, s),
          ),
        ],
      ),
    );
    if (result != null)
      setState(() {
        if (sample == null) {
          if (use != null) {
            if (use.samples == null) use.samples = [];
            use.samples!.add(result);
          }
        } else {
          var i = use!.samples!.indexOf(sample);
          use.samples![i] = result;
        }
      });
  }

  void selectForm({Sample? form}) async {
    final result = await showDialog<Sample>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text("Fill Word Form"),
        contentPadding: const EdgeInsets.all(16),
        children: [
          SampleEditor(
            form ?? Sample(plain: ""),
            (s) => Navigator.pop(context, s),
            translation: false,
          ),
        ],
      ),
    );
    if (result != null)
      setState(() {
        if (form == null)
          entry.forms.add(result);
        else {
          final i = entry.forms.indexOf(form);
          entry.forms[i] = result;
        }
      });
  }

  void uploadEntry() async {}

  void deleteItem<T>(T item, List<T> list) {
    list.remove(item);
  }

  List<Widget> buildList<T>(
    List<T> list,
    Function(T i) onTap,
    Widget Function(T i) builder,
  ) {
    return [
      for (final i in list)
        Row(
          children: [
            Expanded(
              child: Card(
                child: InkWell(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 16,
                    ),
                    child: builder(i),
                  ),
                  onTap: () => onTap(i),
                ),
              ),
            ),
            PopupMenuButton<Function>(
              onSelected: (a) => a(),
              itemBuilder: (BuildContext context) => [
                PopupMenuItem(
                  value: () => setState(() {
                    list.remove(i);
                  }),
                  child: Text(
                    'Delete',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            )
          ],
        )
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
            onPressed: entry.forms.isEmpty ? null : uploadEntry,
            icon: Icon(Icons.publish_outlined),
          ),
          SizedBox(width: 8),
        ],
        bottom: TabBar(
          controller: tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.black,
          tabs: [
            Tab(icon: Icon(Icons.tune_outlined)),
            Tab(icon: Icon(Icons.textsms_outlined)),
            Tab(icon: Icon(Icons.info_outlined)),
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
                    "No entry forms yet.\nAn entry must have at least one form.",
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
              if (entry.uses?.isEmpty ?? true)
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    "No entry uses yet.\n",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black54,
                      fontSize: 24,
                    ),
                  ),
                ),
              if (entry.uses != null)
                ...buildList<Use>(
                  entry.uses!,
                  (u) => selectConcept(use: u),
                  (u) => Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ConceptDisplay(
                        concepts[u.concept]!,
                        scholar: true,
                      ),
                      if (u.samples != null)
                        for (final s in u.samples!) ...[
                          Divider(height: 0),
                          SampleDisplay(s, scholar: true),
                        ],
                    ],
                  ),
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
                grammarTags,
                (t) => setState(
                  () => entry.tags = t,
                ),
                selected: entry.tags,
              ),
            ],
          )
        ],
      ),
    );
  }
}
