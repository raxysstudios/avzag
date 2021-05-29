import 'package:avzag/dictionary/editor/concept_selector.dart';
import 'package:avzag/dictionary/sample/sample.dart';
import 'package:avzag/dictionary/sample/sample_display.dart';
import 'package:flutter/material.dart';

import '../concept_display.dart';
import '../models.dart';
import '../store.dart';
import '../sample/sample_editor.dart';

class EntryEditor extends StatefulWidget {
  EntryEditor(this.sourceEntry);
  final Entry sourceEntry;

  @override
  _EntryEditorState createState() => _EntryEditorState();
}

class _EntryEditorState extends State<EntryEditor>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Entry entry;

  @override
  void initState() {
    super.initState();
    entry = Entry.fromJson(widget.sourceEntry.toJson());
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void selectConcept({Use? use}) async {
    final concept = await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text("Select concept"),
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
    if (concept != null)
      setState(() {
        if (use == null) {
          if (entry.uses == null) entry.uses = [];
          entry.uses!.add(Use(concept: concept));
        } else
          use.concept = concept;
      });
  }

  void selectSample({Use? use, Sample? sample}) async {
    final result = await showDialog<Sample>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text("Fill Sample"),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Text(
                  "Entry editing",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: Colors.blue,
              unselectedLabelColor: Colors.black,
              tabs: [
                Tab(icon: const Icon(Icons.textsms_outlined)),
                Tab(icon: const Icon(Icons.info_outlined)),
              ],
            )
          ],
        ),
        Divider(height: 0),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              ListView(
                padding: const EdgeInsets.all(8),
                children: [
                  if (entry.uses != null)
                    for (final u in entry.uses!) ...[
                      Builder(builder: (context) {
                        final c = concepts[u.concept]!;
                        return InkWell(
                          child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 16,
                              ),
                              child: ConceptDisplay(c)),
                          onTap: () => selectConcept(use: u),
                        );
                      }),
                      if (u.samples != null)
                        for (final s in u.samples!)
                          InkWell(
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 16,
                                ),
                                child: SampleDisplay(s)),
                            onTap: () => selectSample(
                              use: u,
                              sample: s,
                            ),
                          ),
                      OutlinedButton.icon(
                        onPressed: () => selectSample(use: u),
                        icon: Icon(Icons.add_outlined),
                        label: Text("New Sample"),
                      ),
                      Divider(height: 0),
                    ],
                  OutlinedButton.icon(
                    onPressed: selectConcept,
                    icon: Icon(Icons.add_outlined),
                    label: Text("New Usecase"),
                  ),
                ],
              ),
              Text("WIP"),
            ],
          ),
        ),
      ],
    );
  }
}
