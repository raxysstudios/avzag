import 'package:flutter/material.dart';

class TextSample {
  String plain;
  String? ipa;
  String? glossed;
  String? translation;

  TextSample({required this.plain, this.ipa, this.glossed, this.translation});

  TextSample.fromJson(Map<String, dynamic> json)
      : this(
          plain: json['plain'],
          ipa: json['ipa'],
          glossed: json['glossed'],
          translation: json['translation'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['plain'] = plain;
    if (ipa?.isNotEmpty ?? false) data['ipa'] = ipa;
    if (glossed?.isNotEmpty ?? false) data['glossed'] = glossed;
    if (translation?.isNotEmpty ?? false) data['translation'] = translation;
    return data;
  }
}

class TextSampleWidget extends StatelessWidget {
  final TextSample sample;
  final bool scholar;
  final bool row;
  TextSampleWidget(
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
