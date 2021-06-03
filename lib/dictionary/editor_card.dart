import 'package:avzag/store.dart';
import 'package:flutter/material.dart';

import 'entry/entry.dart';
import 'entry/entry_editor.dart';

class DictionaryEditorCard extends StatefulWidget {
  const DictionaryEditorCard({Key? key}) : super(key: key);

  @override
  DictionaryEditorCardState createState() => DictionaryEditorCardState();
}

class DictionaryEditorCardState extends State<DictionaryEditorCard> {
  bool pendingOnly = false;

  @override
  Widget build(BuildContext context) {
    if (editorMode == null) return Offstage();
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EntryEditor(
                Entry(forms: []),
              ),
            ),
          ),
          icon: Icon(Icons.add_box_outlined),
          label: Text('New Entry'),
        ),
        SwitchListTile(
          value: pendingOnly,
          secondary: Icon(Icons.pending_actions_outlined),
          title: Text("Show only pending entries"),
          onChanged: (value) {
            setState(() {
              pendingOnly = value;
            });
          },
        ),
      ],
    );
  }
}
