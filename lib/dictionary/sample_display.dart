import 'package:avzag/dictionary/models.dart';
import 'package:flutter/material.dart';

class SampleDisplay extends StatelessWidget {
  final Sample sample;
  final bool scholar;
  SampleDisplay(this.sample, {this.scholar = true});

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
              "",
              sample.translation,
              ...scholar ? [sample.ipa, sample.glossed] : [],
            ].where((t) => t != null).join("\n"),
            style: TextStyle(
              color: Colors.black54,
            ),
          )
        ],
      ),
    );
  }
}
