import 'package:avzag/home/language_tile.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class EditorSwitch extends StatefulWidget {
  @override
  _EditorSwitchState createState() => _EditorSwitchState();
}

class _EditorSwitchState extends State<EditorSwitch> {
  String? get editorMode => BaseStore.editorMode;

  Future<String?> chooseLanguage() async {
    return await showDialog<String>(
      context: context,
      builder: (_) => SimpleDialog(
        title: Text("Select editing language"),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Text("You can only choose from loaded languages."),
          ),
          Container(
            height: 320,
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.edit_off_outlined),
                  title: Text("None"),
                  selected: editorMode == null,
                  onTap: () => Navigator.pop(context),
                ),
                for (final l in BaseStore.languages)
                  LanguageTile(
                    HomeStore.languages[l]!,
                    selected: editorMode == l,
                    dense: false,
                    onTap: () => Navigator.pop(context, l),
                  ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<UserCredential?> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser?.authentication == null) return null;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text('Editor mode'),
      subtitle: Text(
        capitalize(editorMode ?? 'Off'),
      ),
      value: editorMode != null,
      secondary: Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Icon(Icons.edit_outlined),
      ),
      onChanged: (e) async {
        if (e) {
          final cred = await signInWithGoogle();
          if (cred == null) return;
          print('######### USER ${cred.user?.displayName ?? 'anon'}');
        }
        BaseStore.setEditorMode(await chooseLanguage());
        setState(() {});
      },
    );
  }
}
