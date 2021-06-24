import 'package:avzag/widgets/column_tile.dart';
import 'package:avzag/dictionary/sample/sample_display.dart';
import 'package:avzag/dictionary/use/use_display.dart';
import 'package:flutter/material.dart';

import '../../widgets/note_display.dart';
import '../../utils.dart';
import 'entry.dart';

class EntryDisplay extends StatelessWidget {
  final Entry entry;
  final String language;
  final bool scholar;
  final Widget? leading;
  final Widget? trailing;

  EntryDisplay(
    this.entry, {
    required this.language,
    this.leading,
    this.trailing,
    this.scholar = false,
  });

  Widget build(BuildContext context) {
    return Column(
      children: [
        ColumnTile(
          Text(
            capitalize(entry.forms[0].plain),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: prettyTags(scholar ? entry.tags : null),
          leading: leading,
          trailing: trailing,
          gap: 20,
          padding: const EdgeInsets.symmetric(horizontal: 4),
        ),
        Divider(height: 0),
        Expanded(
          child: ListView(
            children: [
              NoteDisplay(entry.note),
              for (final u in entry.uses) UseDisplay(u, scholar: scholar),
              ColumnTile(
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final f in entry.forms)
                      SampleDisplay(
                        f,
                        scholar: scholar,
                        row: true,
                      ),
                  ],
                ),
                leading: Icon(Icons.tune_outlined),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
