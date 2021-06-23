import 'package:flutter/material.dart';

class NoteDisplay extends StatelessWidget {
  final String? note;
  final EdgeInsetsGeometry padding;

  NoteDisplay(
    this.note, {
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    return note == null
        ? Offstage()
        : Padding(
            padding: padding,
            child: Text(
              note!,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
          );
  }
}
