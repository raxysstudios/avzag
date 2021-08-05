import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/home/store.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/store.dart';
import 'package:avzag/utils.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool loading = false;
  List<String> editable = [];

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      setState(() {
        loading = true;
      });
      updateEditable().then(
        (_) => setState(() {
          loading = false;
        }),
      );
    }
  }

  Future<void> updateEditable() async {
    final token =
        await FirebaseAuth.instance.currentUser?.getIdTokenResult(true);
    setState(() {
      editable = json2list(token?.claims?['languages']) ?? [];
      if (!editable.contains(EditorStore.language)) EditorStore.language = null;
    });
  }

  Future<void> signIn() async {
    setState(() {
      loading = true;
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
      await updateEditable();
    }
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Editors'),
        centerTitle: true,
        bottom: PreferredSize(
          child: LinearProgressIndicator(value: loading ? null : 0),
          preferredSize: Size.fromHeight(4),
        ),
      ),
      backgroundColor: Colors.blueGrey.shade50,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigate(context, null),
        icon: Icon(
          EditorStore.language == null
              ? Icons.edit_off_outlined
              : Icons.edit_outlined,
        ),
        label: Text('Continue'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 64),
        children: [
          Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: ElevatedButton.icon(
                    onPressed: loading ? null : signIn,
                    icon: Icon(Icons.person_outlined),
                    label: Text(
                      EditorStore.email ?? 'Sign In',
                    ),
                  ),
                ),
                if (EditorStore.email == null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Text(
                      'Sign in with Google to see your options.',
                      textAlign: TextAlign.center,
                    ),
                  )
                else ...[
                  Text(
                    'With any question regarding the language materials, contact the corresponding editors below.',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: TextStyle(color: Colors.black87),
                      children: [
                        TextSpan(text: 'You can edit '),
                        TextSpan(
                          text: capitalize(editable.join(', ')),
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(text: ' yourself.'),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                ],
              ],
            ),
          ),
          if (EditorStore.email != null)
            Card(
              child: Column(
                children: [
                  for (final l in BaseStore.languages)
                    Builder(
                      builder: (context) {
                        final language = HomeStore.languages[l]!;
                        final canEdit = editable.contains(l);
                        final editing = l == EditorStore.language;
                        return ListTile(
                          leading: LanguageAvatar(language.name),
                          title: Text(
                            capitalize(l),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          onTap: canEdit
                              ? () => setState(() {
                                    EditorStore.language = editing ? null : l;
                                  })
                              : language.contact == null
                                  ? null
                                  : () => launch(language.contact!),
                          selected: editing,
                          trailing: canEdit
                              ? Icon(Icons.edit_outlined)
                              : language.contact == null
                                  ? null
                                  : Icon(Icons.send_outlined),
                        );
                      },
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
