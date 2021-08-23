import 'package:avzag/global_store.dart';
import 'package:avzag/navigation/auth_page.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';

class EditorSwitch extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text('Editor Mode'),
      subtitle: Text(
        GlobalStore.editing == null ? 'Off' : capitalize(GlobalStore.editing!),
      ),
      value: GlobalStore.editing != null,
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
      },
    );
  }
}
