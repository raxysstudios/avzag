import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:avzag/widgets/loading_dialog.dart';
import 'package:avzag/widgets/segment_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool signing = false;
  List<String> get canEdit => HomeStore.languages.values
      .where((l) => l.editors?.contains(EditorStore.email) ?? false)
      .map((l) => l.name)
      .toList();

  Future<void> signIn() async {
    setState(() {
      signing = true;
    });
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    EditorStore.language = null;

    final user = await GoogleSignIn().signIn();
    if (user != null) {
      final auth = await user.authentication;
      final cred = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: auth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(cred);
    }
    setState(() {
      signing = false;
    });
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
        padding: const EdgeInsets.only(bottom: 64),
        children: [
          SegmentCard(
            children: [
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton.icon(
                  onPressed: () => showLoadingDialog(context, signIn()),
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
                    children: [
                      if (EditorStore.email == null)
                        TextSpan(
                          text: 'Sign in with Google to see your options.',
                        )
                      else ...[
                        TextSpan(
                          text:
                              'With any question regarding the language materials, contact the corresponding editors below.',
                        ),
                        if (canEdit.isNotEmpty) ...[
                          TextSpan(text: '\n\nOr you can edit '),
                          TextSpan(
                            text: capitalize(canEdit.join(', ')),
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          TextSpan(text: ' yourself.'),
                        ],
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (EditorStore.email != null)
            SegmentCard(
              children: [
                Divider(height: 0),
                for (final l in BaseStore.languages)
                  Builder(
                    builder: (context) {
                      final language = HomeStore.languages[l]!;
                      final canEdit = this.canEdit.contains(l);
                      final editing = l == EditorStore.language;
                      return ListTile(
                        leading: Padding(
                          padding: EdgeInsets.only(top: canEdit ? 8 : 0),
                          child: LanguageAvatar(language.name),
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
                            ? () => setState(() {
                                  EditorStore.language = editing ? null : l;
                                })
                            : null,
                        selected: editing,
                        trailing: language.contact == null
                            ? null
                            : IconButton(
                                onPressed: () => launch(language.contact!),
                                icon: Icon(Icons.send_outlined),
                                color: Colors.black,
                                tooltip: "Contact editor",
                              ),
                      );
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
