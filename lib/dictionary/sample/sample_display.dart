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
    return SelectableText.rich(
      TextSpan(
        style: TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
        children: [
          TextSpan(
            text: sample.plain,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          if (sample.translation != null)
            TextSpan(
              text: '\n' + sample.translation!,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          if (scholar)
            TextSpan(
              text: [
                '',
                sample.ipa,
                sample.glossed,
              ].where((t) => t != null).join(row ? ' • ' : '\n'),
            )
        ],
      ),
    );
  }
}
