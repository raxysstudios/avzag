import 'package:avzag/dictionary/sample/sample.dart';
import 'package:flutter/material.dart';

class SampleDisplay extends StatelessWidget {
  final Sample sample;
  final bool scholar;
  final bool row;
  SampleDisplay(
    this.sample, {
    this.scholar = true,
    this.row = false,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: sample.plain,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
        children: [
          TextSpan(
            text: [
              '',
              sample.translation,
              ...scholar ? [sample.ipa, sample.glossed] : [],
            ].where((t) => t != null).join(row ? ' ' : '\n'),
            style: TextStyle(
              wordSpacing: row ? 4 : null,
              color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }
}
