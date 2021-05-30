import 'package:avzag/dictionary/concept/concept_display.dart';
import 'package:avzag/dictionary/sample/sample_display.dart';
import 'package:avzag/dictionary/store.dart';
import 'package:avzag/dictionary/use/use.dart';
import 'package:avzag/dictionary/use/use_display.dart';
import 'package:flutter/material.dart';

import '../../note_display.dart';
import '../../utils.dart';
import 'entry.dart';

class EntryDisplay extends StatefulWidget {
  final Entry entry;
  final bool scholar;

  EntryDisplay(this.entry, {this.scholar = false});

  @override
  _EntryDisplayState createState() => _EntryDisplayState();
}

class _EntryDisplayState extends State<EntryDisplay>
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
      NoteList(
        widget.entry.note,
        padding: const EdgeInsets.only(bottom: 4),
      ),
      for (final f in widget.entry.forms)
        SampleDisplay(
          f,
          scholar: scholar,
          row: true,
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
                          UseDisplay(u, scholar: scholar),
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
