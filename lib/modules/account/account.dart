import 'package:auto_route/auto_route.dart';
import 'package:avzag/models/language.dart';
import 'package:avzag/modules/account/widgets/account_tile.dart';
import 'package:avzag/modules/account/widgets/adminable_languages.dart';
import 'package:avzag/modules/navigation/services/router.gr.dart';
import 'package:avzag/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'widgets/sign_in_buttons.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  User? get user => FirebaseAuth.instance.currentUser;
  var language = EditorStore.language;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Account'),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.done_all_outlined),
        onPressed: () {
          EditorStore.language = language;
          context.pushRoute(const RootRoute());
        },
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 76),
        children: [
          if (user == null)
            SignInButtons(
              onSingIn: () => setState(() {}),
            )
          else ...[
            AccountTile(
              user!,
              onSignOut: () => setState(() {}),
            ),
            AdminableLanguages(
              GlobalStore.languages.values.whereType<Language>(),
              onTap: (l) => setState(() {
                language = l == language ? null : l;
              }),
              selected: language,
            ),
          ],
        ],
      ),
    );
  }
}
