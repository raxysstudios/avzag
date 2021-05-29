import 'dart:ui';

import 'package:flutter/material.dart';

class NoteList extends StatelessWidget {
  final String? note;
  final EdgeInsetsGeometry padding;

  NoteList(
    this.note, {
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return note?.isEmpty ?? false
        ? Offstage()
        : Padding(
            padding: padding,
            child: Text(
              note!,
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
          );
  }
}
