import 'package:avzag/dictionary/sample/sample_display.dart';
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(
            capitalize(widget.entry.forms[0].plain),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Divider(height: 0),
        Expanded(
          child: ListView(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: widget.entry.uses == null
                      ? [Text("No uses data.")]
                      : [
                          for (final u in widget.entry.uses!) ...[
                            UseDisplay(u, scholar: scholar),
                            SizedBox(height: 4),
                          ],
                        ],
                ),
              ),
              Divider(height: 0),
              Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
