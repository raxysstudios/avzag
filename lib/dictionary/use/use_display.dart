import 'package:avzag/utils.dart';
import 'package:avzag/widgets/column_tile.dart';
import 'package:avzag/dictionary/sample/sample_display.dart';
import 'package:avzag/widgets/note_display.dart';
import 'package:flutter/material.dart';
import 'use.dart';

class UseDisplay extends StatelessWidget {
  final Use use;
  final bool scholar;
  const UseDisplay(this.use, {this.scholar = true});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(use.term),
        if (use.definition != null) Text(use.definition!),
        if (use.tags != null)
          ColumnTile(
            Offstage(),
            subtitle: prettyTags(use.tags),
            leading: Icon(Icons.tag_outlined),
          ),
        NoteDisplay(use.note),
        if (use.samples != null)
          for (final s in use.samples!)
            ColumnTile(
              SampleDisplay(s, scholar: scholar),
            )
      ],
    );
  }
}
