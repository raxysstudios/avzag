import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/utils.dart';
import 'package:avzag/phonology/phoneme/phoneme.dart';
import 'package:avzag/widgets/note_display.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class PhonemeDisplay extends StatelessWidget {
  final Phoneme phoneme;
  final String language;
  final String? playing;
  final Function(String)? onPlay;

  const PhonemeDisplay(
    this.phoneme, {
    required this.language,
    this.playing,
    this.onPlay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ColumnTile(
        //   Text(
        //     capitalize(language),
        //     style: TextStyle(
        //       fontSize: 18,
        //       fontWeight: FontWeight.w600,
        //     ),
        //   ),
        //   leading: LanguageAvatar(HomeStore.languages[language]!),
        //   trailing: phoneme.samples == null
        //       ? null
        //       : Text(
        //           Set.from(phoneme.samples!.map((s) => s.letter)).join(' '),
        //           style: TextStyle(
        //             fontSize: 16,
        //             fontWeight: FontWeight.w600,
        //           ),
        //         ),
        // ),
        // if (phoneme.samples != null)
        //   for (final s in phoneme.samples!)
        //     ColumnTile(
        //       Text(
        //         s.word,
        //         style: TextStyle(fontSize: 16),
        //       ),
        //       trailing: Text(
        //         s.ipa ?? '',
        //         style: TextStyle(color: Colors.black54),
        //       ),
        //       leading: Icon(
        //         playing == s.audioUrl && s.audioUrl != null
        //             ? Icons.pause_outlined
        //             : Icons.play_arrow_outlined,
        //         color: Colors.black,
        //       ),
        //       onTap: onPlay == null
        //           ? null
        //           : () async {
        //               if (s.audioUrl == null)
        //                 s.audioUrl = await FirebaseStorage.instance
        //                     .ref('$language/phonology/${s.word}.m4a')
        //                     .getDownloadURL();
        //               onPlay!(s.audioUrl!);
        //             },
        //     ),
        // NoteDisplay(phoneme.note),
      ],
    );
  }
}
