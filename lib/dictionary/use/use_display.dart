import 'package:avzag/dictionary/concept/concept_display.dart';
import 'package:avzag/dictionary/sample/sample_display.dart';
import 'package:avzag/dictionary/store.dart';
import 'package:avzag/note_display.dart';
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
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: ConceptDisplay(
            concepts[use.concept]!,
            scholar: scholar,
          ),
        ),
        NoteList(
          use.note,
          padding: const EdgeInsets.only(bottom: 4),
        ),
        if (use.samples != null)
          for (final s in use.samples!)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: SampleDisplay(s, scholar: scholar),
            )
      ],
    );
  }
}