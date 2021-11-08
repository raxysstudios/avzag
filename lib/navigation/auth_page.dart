import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/global_store.dart';
import 'package:avzag/utils/utils.dart';
import 'package:avzag/widgets/loading_card.dart';
import 'package:avzag/widgets/span_icon.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

import 'nav_drawer.dart';

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
    setState(() {
      EditorStore.language = null;
      EditorStore.isAdmin = false;
      editable.clear();
    });

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
        title: const Text('Editor Mode'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => navigate(context),
        child: const Icon(Icons.done_all_outlined),
        tooltip: 'Continue',
      ),
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
                  icon: const Icon(Icons.login_outlined),
                  label: Text(
                    EditorStore.email ?? 'Sign In',
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  EditorStore.uid == null
                      ? 'Sign in to see your options.'
                      : 'With any question regarding the language materials, use the contacts below.',
                  style: Theme.of(context).textTheme.bodyText2,
                  textAlign: TextAlign.center,
                ),
                if (editable.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.bodyText2,
                      children: [
                        const TextSpan(text: 'You have '),
                        WidgetSpan(
                          child: SpanIcon(
                            Icons.account_circle_outlined,
                            color: Theme.of(context).textTheme.bodyText2?.color,
                          ),
                        ),
                        const TextSpan(
                          text: 'admin',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const TextSpan(text: ' rights for '),
                        TextSpan(
                          text: capitalize(editable.join(', ')),
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const TextSpan(text: '.'),
                      ],
                    ),
                  ),
                ],
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
