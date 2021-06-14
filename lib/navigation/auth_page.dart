import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/navigation/nav_drawer.dart';
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
  Future<void> signIn() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    await EditorStore.setLanguage(null);

    final user = await GoogleSignIn().signIn();
    if (user?.authentication == null) return;

    final auth = await user!.authentication;
    final cred = GoogleAuthProvider.credential(
      accessToken: auth.accessToken,
      idToken: auth.idToken,
    );
    await FirebaseAuth.instance.signInWithCredential(cred);
  }

  Widget? contactButton(String language) {
    String? contact;
    for (final user in EditorStore.admins.values)
      if (user.editor?.contains(language) ?? false) {
        contact = user.contact;
        break;
      }
    if (contact != null)
      return IconButton(
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
        leading: BackButton(
          onPressed: () => navigate(context, null),
        ),
        title: Text('Editors'),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: () => signIn().then((_) => setState(() {})),
              icon: Icon(Icons.person_outlined),
              label: Text(
                EditorStore.email ?? 'Sign In',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(8, 0, 8, 16),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(color: Colors.black87),
                children: EditorStore.email == null
                    ? [
                        TextSpan(
                          text: 'Sign in with Google to see your options.',
                        ),
                      ]
                    : [
                        TextSpan(
                          text:
                              'With any question regarding the language materials, contact the correspondng editors below.',
                        ),
                        if (EditorStore.admin?.editor?.isNotEmpty ?? false) ...[
                          TextSpan(text: '\n\nOr you can edit '),
                          for (final l in EditorStore.admin!.editor!)
                            TextSpan(
                              text: capitalize(l),
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          TextSpan(text: ' youself.'),
                        ],
                      ],
              ),
            ),
          ),
          if (EditorStore.email != null) ...[
            Divider(height: 0),
            for (final l in BaseStore.languages)
              Builder(
                builder: (context) {
                  final canEdit = EditorStore.canEdit(l);
                  final editing = l == EditorStore.language;
                  return ListTile(
                    leading: Padding(
                      padding: EdgeInsets.only(top: canEdit ? 8 : 0),
                      child: LanguageAvatar(HomeStore.languages[l]!),
                    ),
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
                                ? 'You are editing this language'
                                : 'You can edit this language',
                          )
                        : null,
                    onTap: canEdit
                        ? () => EditorStore.setLanguage(
                              editing ? null : l,
                            ).then((_) => setState(() {}))
                        : null,
                    selected: editing,
                    trailing: contactButton(l),
                  );
                },
              ),
          ],
        ],
      ),
    );
  }
}
