import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/global_store.dart';
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
      if (GlobalStore.editing != null &&
          !editable.contains(GlobalStore.editing)) GlobalStore.editing = null;
    });
  }

  Future<void> signIn() async {
    setState(() {
      loading = true;
    });
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
    GlobalStore.editing = null;

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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigate(context, null),
        icon: Icon(
          GlobalStore.editing == null
              ? Icons.edit_off_outlined
              : Icons.edit_outlined,
        ),
        label: Text('Continue'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 76),
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
                      GlobalStore.email ?? 'Sign In',
                    ),
                  ),
                ),
                if (GlobalStore.email == null)
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
          if (GlobalStore.email != null)
            Card(
              child: Column(
                children: [
                  for (final l in GlobalStore.languages.values)
                    Builder(
                      builder: (context) {
                        final canEdit = editable.contains(l.name);
                        final editing = l.name == GlobalStore.editing;
                        return ListTile(
                          leading: LanguageAvatar(l.flag),
                          title: Text(
                            capitalize(l.name),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () {
                            if (canEdit)
                              setState(() {
                                GlobalStore.editing = editing ? null : l.name;
                              });
                            else if (l.contact != null) launch(l.contact!);
                          },
                          selected: editing,
                          trailing: canEdit
                              ? Icon(Icons.edit_outlined)
                              : l.contact == null
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
