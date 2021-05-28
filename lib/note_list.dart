import 'dart:ui';

import 'package:flutter/material.dart';

class NoteList extends StatelessWidget {
  final List<String>? notes;

  NoteList(this.notes);

  @override
  Widget build(BuildContext context) {
    return notes == null
        ? Offstage()
        : Text(
            notes!.join('\n'),
            style: TextStyle(fontStyle: FontStyle.italic),
          );
  }
}
