import 'package:auto_route/auto_route.dart';
import 'package:bazur/navigation/router.gr.dart';
import 'package:bazur/shared/utils.dart';
import 'package:bazur/shared/widgets/raxys.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'widgets/account_tile.dart';
import 'widgets/editor_mode_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => context.navigateTo(const RootRoute()),
          icon: const Icon(Icons.arrow_back_outlined),
        ),
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: () => openLink('https://raxys.app'),
            tooltip: 'Made with honor in North Caucasus',
            icon: const Raxys(),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 76),
        children: [
          const AccountTile(),
          const EditorModeCard(),
          ListTile(
            leading: const Icon(Icons.send_outlined),
            title: const Text('Developer contact'),
            subtitle: const Text('Raxys Studios'),
            onTap: () => openLink('https://t.me/raxysstudios'),
          ),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, status) {
              final p = status.data;
              return ListTile(
                leading: const Icon(Icons.code_outlined),
                title: const Text('GitHub repository'),
                subtitle: Text(
                  p == null
                      ? 'Loading...'
                      : 'v${p.version} • b${p.buildNumber}',
                ),
                onTap: () => openLink(
                  'https://github.com/raxysstudios/bazur',
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
