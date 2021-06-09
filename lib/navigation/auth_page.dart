import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  Future<String?> signIn() async {
    final googleUser = await GoogleSignIn().signIn();
    if (googleUser?.authentication == null) return null;

    final googleAuth = await googleUser!.authentication;
    final authCred = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await FirebaseAuth.instance.signInWithCredential(authCred);
    setState(() {});
    return userCred.user?.email;
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    EditorStore.setLanguage(null);
    setState(() {});
  }

  Widget contactButton(String language) {
    String? contact;
    for (final user in EditorStore.admins.values)
      if (user.editor?.contains(language) ?? false) {
        contact = user.contact;
        break;
      }
    return contact == null
        ? Offstage()
        : IconButton(
            onPressed: () => launch(contact!),
            icon: Icon(Icons.send_outlined),
            color: Colors.black,
            tooltip: "Contact editor",
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editors'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: () async {
                if (EditorStore.email != null) {
                  await signOut();
                  await EditorStore.setLanguage(null);
                  setState(() {});
                }
                await signIn();
              },
              icon: Icon(Icons.account_circle_outlined),
              label: Text(EditorStore.email ?? "Sign in to see your options"),
            ),
          ),
          for (final l in BaseStore.languages)
            Builder(
              builder: (context) {
                final canEdit = EditorStore.canEdit(l);
                final editing = l == EditorStore.language;
                return ListTile(
                  title: Text(
                    capitalize(l),
                    style: TextStyle(
                      color: canEdit ? null : Colors.black54,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: canEdit
                      ? Text(
                          editing
                              ? 'Editing this language'
                              : 'You can edit this language',
                        )
                      : null,
                  onTap: canEdit
                      ? () async {
                          await EditorStore.setLanguage(
                            editing ? null : l,
                          );
                          setState(() {});
                        }
                      : null,
                  selected: editing,
                  trailing: contactButton(l),
                );
              },
            ),
        ],
      ),
    );
  }
}
