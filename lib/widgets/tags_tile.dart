import 'package:avzag/utils.dart';
import 'package:avzag/widgets/editor_dialog.dart';
import 'package:flutter/material.dart';

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
    final theme = Theme.of(context).textTheme.caption;
    return ListTile(
      minVerticalPadding: 12,
      leading: Icon(Icons.tag_outlined),
      title: (tags?.isEmpty ?? true)
          ? Text(
              'Tap to add tags',
              style: theme,
            )
          : Builder(builder: (context) {
              final style = TextStyle(
                color: theme?.color,
              );
              final data = prettyTags(tags, capitalized: false)!;
              return onEdited == null
                  ? SelectableText(data, style: style)
                  : Text(data, style: style);
            }),
      onTap: onEdited == null ? null : () => showEditor(context),
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
        ),
      ],
    );
  }
}
