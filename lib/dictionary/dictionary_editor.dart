import 'package:avzag/store.dart';
import 'package:flutter/material.dart';
import 'entry/entry.dart';
import 'entry/entry_editor.dart';

class DictionaryEditor extends StatefulWidget {
  const DictionaryEditor({Key? key}) : super(key: key);

  @override
  DictionaryEditorState createState() => DictionaryEditorState();
}

class DictionaryEditorState extends State<DictionaryEditor> {
  bool pendingOnly = false;

  @override
  Widget build(BuildContext context) {
    if (EditorStore.language == null) return Offstage();
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
