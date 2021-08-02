import 'package:avzag/widgets/editor_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NoteTile extends StatelessWidget {
  final String? note;
  final ValueSetter<String?>? onEdited;

  const NoteTile(
    this.note, {
    this.onEdited,
  });

  @override
  Widget build(BuildContext context) {
    if (note == null && onEdited == null) return Offstage();
    return ListTile(
      minVerticalPadding: 12,
      leading: Icon(Icons.info_outline),
      title: note?.isEmpty ?? true
          ? Text(
              'Tap to add note',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            )
          : MarkdownBody(
              data: note!,
              selectable: onEdited == null,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  fontSize: 16,
                ),
                strong: TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
      onTap: onEdited == null
          ? null
          : () {
              var result = note;
              showEditorDialog(
                context,
                result: () => result,
                callback: onEdited!,
                title: 'Edit note',
                content: TextFormField(
                  initialValue: note,
                  maxLines: null,
                  onChanged: (value) {
                    result = value.trim();
                  },
                  decoration: InputDecoration(
                    labelText: 'Note (markdown supported)',
                  ),
                ),
              );
            },
    );
  }
}
