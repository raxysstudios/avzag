import 'package:avzag/home/language_card.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';

class EditorSwitch extends StatefulWidget {
  @override
  _EditorSwitchState createState() => _EditorSwitchState();
}

class _EditorSwitchState extends State<EditorSwitch> {
  Future<String?> chooseLanguage() async {
    return await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text("Select language"),
        contentPadding: const EdgeInsets.all(16),
        children: [
          Container(
            height: 512,
            child: ListView(
              children: [
                for (final l in languages)
                  LanguageCard(
                    l,
                    onTap: () => Navigator.pop(
                      context,
                      l.name,
                    ),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text('Editor mode'),
      subtitle: Text(
        editorMode == null ? 'Off' : capitalize(editorMode!),
      ),
      value: editorMode != null,
      secondary: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Icon(Icons.edit_outlined),
      ),
      onChanged: (e) async {
        final mode = e ? await chooseLanguage() : null;
        setState(() => editorMode = mode);
      },
    );
  }
}
