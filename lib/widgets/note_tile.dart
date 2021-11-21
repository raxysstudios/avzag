import 'package:avzag/widgets/editor_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteTile extends StatelessWidget {
  final String? note;
  final ValueSetter<String?>? onEdited;

  const NoteTile(
    this.note, {
    Key? key,
    this.onEdited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (note == null && onEdited == null) return const Offstage();
    return ListTile(
      minVerticalPadding: 12,
      leading: const Icon(Icons.info_rounded),
      title: note?.isEmpty ?? true
          ? Text(
              'Tap to add note',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).textTheme.caption?.color,
              ),
            )
          : MarkdownBody(
              data: note!,
              selectable: onEdited == null,
              styleSheet: MarkdownStyleSheet(
                p: const TextStyle(
                  fontSize: 16,
                ),
                strong: const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
              ),
              onTapLink: (_, link, __) {
                if (link != null) launch(link);
              },
            ),
      onTap: onEdited == null ? null : () => showEditor(context),
    );
  }

  void showEditor(BuildContext context) {
    var result = note;
    showEditorDialog(
      context,
      result: () => result,
      callback: onEdited!,
      title: 'Edit note',
      children: [
        TextFormField(
          autofocus: true,
          initialValue: note,
          maxLines: null,
          onChanged: (value) {
            result = value.trim();
          },
          decoration: const InputDecoration(
            labelText: 'Note (markdown supported)',
          ),
          validator: emptyValidator,
        ),
      ],
    );
  }
}
