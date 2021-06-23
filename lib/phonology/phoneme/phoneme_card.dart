import 'package:avzag/phonology/phoneme/phoneme.dart';
import 'package:flutter/material.dart';

class PhonemeCard extends StatelessWidget {
  final Phoneme phoneme;
  final String language;
  final String? playing;
  final Function(String)? onPlay;

  const PhonemeCard(
    this.phoneme, {
    required this.language,
    this.playing,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          Text(language),
          if (phoneme.samples != null)
            for (final s in phoneme.samples!)
              InkWell(
                onTap: s.audioUrl == null || onPlay == null
                    ? null
                    : () => onPlay!(s.audioUrl!),
                child: Row(
                  children: [
                    if (s.audioUrl != null && onPlay != null) ...[
                      Icon(
                        playing == s.audioUrl
                            ? Icons.pause_outlined
                            : Icons.play_arrow_outlined,
                      ),
                      SizedBox(width: 8),
                    ],
                    Expanded(child: Text(s.word)),
                    if (s.ipa != null) ...[
                      SizedBox(width: 8),
                      Text(s.ipa!),
                    ],
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
