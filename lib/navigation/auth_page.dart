import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/navigation/nav_drawer.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/utils/utils.dart';
import 'package:avzag/widgets/loading_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

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
      editable = json2list(token?.claims?['admin']) ?? [];
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
        title: const Text('Editors'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => navigate(context, null),
        icon: Icon(EditorStore.isEditing
            ? Icons.edit_outlined
            : Icons.edit_off_outlined),
        label: const Text('Continue'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: ListView(
        padding: const EdgeInsets.only(bottom: 76),
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton.icon(
                  onPressed: loading ? null : signIn,
                  icon: const Icon(Icons.person_outlined),
                  label: Text(
                    EditorStore.email ?? 'Sign In',
                  ),
                ),
                const SizedBox(height: 8),
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: Theme.of(context).textTheme.bodyText2,
                    children: [
                      const TextSpan(
                        text:
                            'With any question regarding the language materials, use the contacts below.',
                      ),
                      if (EditorStore.email != null) ...[
                        const TextSpan(text: '\n\nYou have admin rights for '),
                        TextSpan(
                          text: capitalize(editable.join(', ')),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ]
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (loading)
            const Padding(
              padding: EdgeInsets.all(16),
              child: LoadingCard(),
            ),
          if (EditorStore.email != null)
            Card(
              child: Column(
                children: [
                  for (final l in GlobalStore.languages.values)
                    Builder(
                      builder: (context) {
                        final editing = l.name == EditorStore.language;
                        final isAdmin = editable.contains(l.name);
                        return ListTile(
                          leading: LanguageAvatar(l.flag),
                          title: Text(
                            capitalize(l.name),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 18,
                            ),
                          ),
                          onTap: () => setState(() {
                            EditorStore.language = editing ? null : l.name;
                            EditorStore.isAdmin = !editing && isAdmin;
                          }),
                          selected: editing,
                          trailing: l.contact == null
                              ? null
                              : IconButton(
                                  onPressed: () => launch(l.contact!),
                                  icon: const Icon(Icons.send_outlined),
                                  tooltip: "Contact admin",
                                ),
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
