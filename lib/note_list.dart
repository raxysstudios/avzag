import 'dart:ui';

import 'package:flutter/material.dart';

class NoteList extends StatelessWidget {
  final List<String>? notes;

  NoteList(this.notes);

  @override
  Widget build(BuildContext context) {
    return notes == null
        ? Offstage()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final n in notes!)
                Text(
                  n,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          );
  }
}
