import 'dart:ui';

import 'package:flutter/material.dart';

class NoteDisplay extends StatelessWidget {
  final String? note;
  final EdgeInsetsGeometry padding;

  NoteDisplay(
    this.note, {
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return note == null
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
