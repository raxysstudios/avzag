import 'package:avzag/utils.dart';
import 'package:avzag/widgets/editor_dialog.dart';
import 'package:flutter/material.dart';

class TagsTile extends StatelessWidget {
  final List<String>? tags;
  final ValueSetter<List<String>?>? onEdited;

  TagsTile(this.tags, {this.onEdited});

  @override
  Widget build(BuildContext context) {
    if (tags == null && onEdited == null) return Offstage();
    return ListTile(
      leading: Icon(Icons.tag_outlined),
      title: (tags?.isEmpty ?? true)
          ? Text(
              'Tap to add tags',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            )
          : Text(
              prettyTags(tags)!,
              style: TextStyle(color: Colors.black54),
            ),
      onTap: onEdited == null
          ? null
          : () {
              final result = EditorDialogResult(tags);
              showEditorDialog(
                context,
                result: result,
                setter: onEdited!,
                title: 'Edit tags',
                content: TextFormField(
                  initialValue: tags?.join(' '),
                  onChanged: (value) {
                    value = value.trim();
                    result.value = value.isEmpty ? null : value.split(' ');
                  },
                ),
              );
            },
    );
  }
}
