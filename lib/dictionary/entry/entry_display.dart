import 'package:avzag/dictionary/sample/sample_display.dart';
import 'package:avzag/dictionary/use/use_display.dart';
import 'package:avzag/store.dart';
import 'package:flutter/material.dart';

import '../../widgets/note_display.dart';
import '../../utils.dart';
import 'entry.dart';
import 'entry_editor.dart';

class EntryDisplay extends StatefulWidget {
  final Entry entry;
  final String language;
  final bool scholar;
  final void Function()? toggleScholar;

  EntryDisplay(
    this.entry, {
    required this.language,
    this.scholar = false,
    this.toggleScholar,
  });

  @override
  _EntryDisplayState createState() => _EntryDisplayState();
}

class _EntryDisplayState extends State<EntryDisplay>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late bool scholar;

  @override
  void initState() {
    scholar = widget.scholar;
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
    return Container(
      height: 512,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    capitalize(widget.entry.forms[0].plain),
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              if (widget.language == EditorStore.language)
                IconButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EntryEditor(
                          entry: widget.entry,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.edit_outlined),
                  tooltip: 'Edit this entry',
                ),
              IconButton(
                onPressed: () {
                  setState(() {
                    scholar = !scholar;
                  });
                  widget.toggleScholar?.call();
                },
                icon: Icon(
                  Icons.school_outlined,
                  color: scholar ? Colors.blue : null,
                ),
                tooltip: 'Toggle Scholar mode',
              ),
              SizedBox(width: 4),
            ],
          ),
          Divider(height: 0),
          Expanded(
            child: ListView(
              children: [
                if (scholar && widget.entry.tags != null ||
                    (widget.entry.note?.isNotEmpty ?? false)) ...[
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (scholar && widget.entry.tags != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              widget.entry.tags!.join(' '),
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        NoteDisplay(widget.entry.note),
                      ],
                    ),
                  ),
                  Divider(height: 0),
                ],
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: widget.entry.uses == null
                        ? [Text('No uses data.')]
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
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
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
      ),
    );
  }
}
