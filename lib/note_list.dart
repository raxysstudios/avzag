import 'package:flutter/material.dart';

class NoteList extends StatelessWidget {
  final List<String>? notes;

  NoteList(this.notes);

  @override
  Widget build(BuildContext context) {
    return notes == null
        ? Offstage()
        : Column(
            children: [
              for (final n in notes!) Text(n),
            ],
          );
  }
}
