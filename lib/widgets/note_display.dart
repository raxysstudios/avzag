import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NoteDisplay extends StatelessWidget {
  final String? note;
  final ValueSetter<String?>? onEdited;

  NoteDisplay(this.note, {this.onEdited});

  void edit(BuildContext context) {
    showDialog<String?>(
      context: context,
      builder: (context) {
        final controller = TextEditingController(text: note);
        return AlertDialog(
          title: Text('Edit note (markdown)'),
          content: TextField(
            controller: controller,
          ),
          actions: [
            TextButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.delete),
              label: Text('Delete'),
            ),
            Spacer(),
            TextButton.icon(
              onPressed: () => Navigator.pop(context, note),
              icon: Icon(Icons.cancel),
              label: Text('Close'),
            ),
            TextButton.icon(
              onPressed: () => Navigator.pop(context, controller.text),
              icon: Icon(Icons.check),
              label: Text('Confirm'),
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
      leading: Icon(
        onEdited == null ? Icons.info_outline : Icons.edit_outlined,
      ),
      title: MarkdownBody(
        data: note ?? '',
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
