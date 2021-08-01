import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NoteTile extends StatelessWidget {
  final String? note;
  final ValueSetter<String?>? onEdited;

  NoteTile(this.note, {this.onEdited});

  void edit(BuildContext context) {
    showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        var note = this.note;
        return AlertDialog(
          title: Text('Edit markdown note'),
          content: TextFormField(
            initialValue: note,
            onChanged: (value) {
              note = value;
            },
          ),
          actions: [
            Row(
              // mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(context, this.note),
                  child: Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, note),
                  child: Text('SAVE'),
                ),
              ],
            ),
          ],
        );
      },
    ).then((value) => onEdited!(value));
  }

  @override
  Widget build(BuildContext context) {
    if (note == null && onEdited == null) return Offstage();
    return ListTile(
      leading: Icon(Icons.note_outlined),
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
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
      onTap: onEdited == null ? null : () => edit(context),
    );
  }
}
