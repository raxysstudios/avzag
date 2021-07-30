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
        ListTile(
          leading: Icon(Icons.lightbulb_outline),
          title: Text(
            capitalize(use.term),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: use.definition == null
              ? null
              : Text(
                  use.definition!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.normal,
                  ),
                ),
        ),
        if (use.tags != null)
          ListTile(
            leading: Icon(Icons.tag_outlined),
            title: Text(
              prettyTags(use.tags)!,
              style: TextStyle(color: Colors.black54),
            ),
          ),
        NoteDisplay(use.note),
        if (use.samples != null)
          for (var i = 0; i < use.samples!.length; i++)
            ListTile(
              leading: Icon(
                Icons.bookmark_outline,
                color: i == 0 ? null : Colors.transparent,
              ),
              title: SampleDisplay(
                use.samples![i],
                scholar: scholar,
              ),
            )
      ],
    );
  }
}
