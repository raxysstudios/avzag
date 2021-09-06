import 'package:avzag/utils.dart';
import 'package:avzag/widgets/editor_dialog.dart';
import 'package:flutter/material.dart';
import 'snackbar_manager.dart';

class TagsTile extends StatelessWidget {
  final List<String>? tags;
  final ValueSetter<List<String>?>? onEdited;

  const TagsTile(
    this.tags, {
    this.onEdited,
  });

  @override
  Widget build(BuildContext context) {
    if (tags == null && onEdited == null) return Offstage();
    return ListTile(
      minVerticalPadding: 12,
      leading: Icon(Icons.tag_outlined),
      title: (tags?.isEmpty ?? true)
          ? Text(
              'Tap to add tags',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Theme.of(context).textTheme.caption?.color,
              ),
            )
          : Text(
              prettyTags(
                tags,
                capitalized: false,
              )!,
            ),
      onTap: onEdited == null ? null : () => showEditor(context),
      onLongPress: onEdited == null
          ? () => copyText(
                context,
                tags!.join(' '),
              )
          : null,
    );
  }

  void showEditor(BuildContext context) {
    var result = tags?.join(' ');
    showEditorDialog(
      context,
      result: () => result!.split(' ').where((e) => e.isNotEmpty).toList(),
      callback: onEdited!,
      title: 'Edit tags',
      children: [
        TextFormField(
          autofocus: true,
          initialValue: tags?.join(' '),
          onChanged: (value) {
            result = value.trim();
          },
          decoration: InputDecoration(
            labelText: 'Space-separated, without the #-character',
          ),
          validator: emptyValidator,
          inputFormatters: [LowerCaseTextFormatter()],
        ),
      ],
    );
  }
}
