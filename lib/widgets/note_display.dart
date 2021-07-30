import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NoteDisplay extends StatelessWidget {
  final String? note;
  final EdgeInsetsGeometry padding;

  NoteDisplay(
    this.note, {
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    if (note == null) return Offstage();
    return ListTile(
      leading: Icon(Icons.info_outline),
      title: MarkdownBody(
        data: note!,
        selectable: true,
        styleSheet: MarkdownStyleSheet(
          p: TextStyle(
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
