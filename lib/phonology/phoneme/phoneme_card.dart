import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/utils.dart';
import 'package:avzag/widgets/column_tile.dart';
import 'package:avzag/phonology/phoneme/phoneme.dart';
import 'package:avzag/widgets/note_display.dart';
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
    return Column(
      children: [
        ColumnTile(
          Text(
            capitalize(language),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          leading: LanguageAvatar(HomeStore.languages[language]!),
          trailing: Text(
            phoneme.samples?.map((s) => s.letter).join(' ') ?? '',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        if (phoneme.samples != null)
          for (final s in phoneme.samples!)
            ColumnTile(
              Text(
                s.word,
                style: TextStyle(fontSize: 16),
              ),
              trailing: Text(
                s.ipa ?? '',
                style: TextStyle(color: Colors.black54),
              ),
              leading: Icon(
                playing == s.audioUrl
                    ? Icons.pause_outlined
                    : Icons.play_arrow_outlined,
                color: Colors.black,
              ),
              onTap: s.audioUrl == null || onPlay == null
                  ? null
                  : () => onPlay!(s.audioUrl!),
            ),
        NoteDisplay(phoneme.note),
      ],
    );
  }
}
