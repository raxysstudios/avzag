import 'package:avzag/dictionary/store.dart';
import 'package:flutter/material.dart';

import '../note_list.dart';
import '../utils.dart';
import 'models.dart';

class EntryCard extends StatefulWidget {
  final Entry entry;
  final bool scholar;

  EntryCard(this.entry, {this.scholar = false});

  @override
  _EntryCardState createState() => _EntryCardState();
}

class _EntryCardState extends State<EntryCard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool get scholar => widget.scholar;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<Widget> buildUse(Use use) {
    final concept = concepts[use.concept]!;
    return [
      Padding(
        padding: const EdgeInsets.only(bottom: 4),
        child: RichText(
          text: TextSpan(
            text: capitalize(concept.meaning),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
            children: scholar && concept.tags != null
                ? [
                    TextSpan(
                      text: " " + concept.tags!.join(" "),
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ]
                : null,
          ),
        ),
      ),
      if (use.notes != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: NoteList(use.notes),
        ),
      if (use.samples != null)
        for (final s in use.samples!)
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: RichText(
              text: TextSpan(
                text: s.plain,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: [
                      "",
                      s.translation,
                      ...scholar ? [s.ipa, s.glossed] : [],
                    ].where((t) => t != null).join("\n"),
                    style: TextStyle(
                      color: Colors.black54,
                    ),
                  )
                ],
              ),
            ),
          ),
    ];
  }

  List<Widget> buildForms() {
    return [
      if (scholar && widget.entry.tags != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            widget.entry.tags!.join(" "),
            style: TextStyle(
              color: Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      if (widget.entry.notes != null)
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: NoteList(widget.entry.notes),
        ),
      for (final f in widget.entry.forms)
        RichText(
          text: TextSpan(
            text: f.plain,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
            children: scholar
                ? [
                    TextSpan(
                      text: ["", f.ipa, f.glossed]
                          .where((e) => e != null)
                          .join(' '),
                      style: TextStyle(
                        wordSpacing: 4,
                        color: Colors.black54,
                      ),
                    ),
                  ]
                : null,
          ),
        ),
    ];
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
                  capitalize(widget.entry.forms[0].plain),
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
                children: widget.entry.uses == null
                    ? [Text("No uses data.")]
                    : [
                        for (final u in widget.entry.uses!) ...[
                          ...buildUse(u),
                          Divider(
                            height: 4,
                            color: Colors.transparent,
                          ),
                        ],
                      ],
              ),
              ListView(
                padding: const EdgeInsets.all(8),
                children: buildForms(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
