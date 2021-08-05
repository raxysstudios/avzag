import 'package:avzag/navigation/auth_page.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';

class EditorSwitch extends StatefulWidget {
  @override
  _EditorSwitchState createState() => _EditorSwitchState();
}

class _EditorSwitchState extends State<EditorSwitch> {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text('Editor Mode'),
      subtitle: Text(
        EditorStore.language == null
            ? 'Off'
            : capitalize(EditorStore.language!),
      ),
      value: EditorStore.language != null,
      secondary: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Icon(Icons.edit_outlined),
      ),
      onChanged: (e) async {
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AuthPage(),
          ),
        );
        setState(() {});
      },
    );
  }
}
