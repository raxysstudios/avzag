import 'package:auto_route/auto_route.dart';
import 'package:avzag/models/language.dart';
import 'package:avzag/navigation/router.gr.dart';
import 'package:avzag/shared/utils.dart';
import 'package:avzag/shared/widgets/raxys.dart';
import 'package:avzag/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'widgets/account_tile.dart';
import 'widgets/editor_languages.dart';
import 'widgets/sign_in_buttons.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  User? get user => FirebaseAuth.instance.currentUser;
  var language = EditorStore.language;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AutoLeadingButton(),
        title: const Text('Settings'),
        actions: const [
          Raxys(),
          SizedBox(width: 4),
        ],
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
            EditorLanguages(
              GlobalStore.languages.values.whereType<Language>(),
              onTap: (l) => setState(() {
                language = l == language ? null : l;
              }),
              selected: language,
            ),
          ],
          ListTile(
            leading: const Icon(Icons.send_outlined),
            title: const Text('Developer Contact'),
            subtitle: const Text('Raxys Studios'),
            onTap: () => openLink('https://t.me/raxysstudios'),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, status) {
              final p = status.data;
              return ListTile(
                leading: const Icon(Icons.code_outlined),
                title: const Text('GitHub Repository'),
                subtitle: Text(
                  p == null ? '...' : 'v${p.version} • b${p.buildNumber}',
                ),
                onTap: () => openLink(
                  'https://github.com/raxysstudios/avzag',
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.get_app_outlined),
            title: Row(
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: () => openLink(
                      'https://play.google.com/store/apps/details?id=com.alkaitagi.avzag',
                    ),
                    child: const Text('Google Play'),
                  ),
                ),
                Expanded(
                  child: TextButton(
                    onPressed: () => openLink(
                      'https://apps.apple.com/app/avzag-languages-of-caucasus/id1603226004',
                    ),
                    child: const Text('App Store'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
