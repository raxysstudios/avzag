import 'package:avzag/dictionary/concept/concept_display.dart';
import 'package:avzag/dictionary/sample/sample_display.dart';
import 'package:avzag/dictionary/store.dart';
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
        ConceptDisplay(
          DictionaryStore.concepts[use.concept]!,
          scholar: scholar,
        ),
        for (final s in use.samples ?? [])
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: SampleDisplay(s, scholar: scholar),
          )
      ],
    );
  }
}
