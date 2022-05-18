import 'package:avzag/modules/dictionary/screens/dictionary.dart';
import 'package:avzag/modules/home/screens/home.dart';
import 'package:avzag/shared/utils/open_link.dart';
import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/expandable_tile.dart';
import 'package:avzag/shared/widgets/raxys_logo.dart';
import 'package:avzag/shared/widgets/span_icon.dart';
import 'package:avzag/store.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'account.dart';

Future<void> navigate(
  BuildContext context, [
  String? title,
]) async {
  final prefs = await SharedPreferences.getInstance();
  if (title == null) {
    title = prefs.getString('module');
    if (title == null || title == 'home') title = 'dictionary';
  }

  late Widget Function(BuildContext) builder;
  if (title == 'home') {
    builder = (_) => const HomeScreen();
    title = null;
  } else if (title == 'dictionary') {
    builder = (_) => const DictionaryScreen();
  } else {
    builder = (_) => const Text('No Route');
  }

  if (title != null) await prefs.setString('module', title);
  await Navigator.pushReplacement<void, void>(
    context,
    MaterialPageRoute(builder: builder),
  );
}

class _NavModule {
  final IconData icon;
  final String text;
  _NavModule(this.icon, this.text);

  Widget build(BuildContext context, [String? route]) {
    final enabled = route != null;
    return ListTile(
      leading: Icon(icon),
      title: Text(
        capitalize(text),
        style: const TextStyle(fontSize: 18),
      ),
      trailing: enabled ? null : const Icon(Icons.construction_rounded),
      selected: route == text,
      onTap: enabled ? () => navigate(context, text) : null,
      enabled: enabled,
    );
  }
}

class NavDraver extends StatelessWidget {
  final String? title;

  const NavDraver({
    Key? key,
    this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            ExpandableTile(
              header: const ListTile(
                leading: RaxysLogo(
                  opacity: .1,
                  scale: 7,
                ),
                contentPadding: EdgeInsets.only(left: 16),
                title: Text(
                  'Ævzag',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              body: ColumnCard(
                divider: null,
                margin: const EdgeInsets.only(bottom: 12),
                children: [
                  ListTile(
                    leading: const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Icon(Icons.send_rounded),
                    ),
                    title: const Text('Developer Contact'),
                    subtitle: const Text('Raxys Studios'),
                    onTap: () => openLink('https://t.me/raxysstudios'),
                  ),
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      var info = 'Loading...';
                      final package = snapshot.data;
                      if (package != null) {
                        info = [
                          'v${package.version}',
                          'b${package.buildNumber}'
                        ].join(' • ');
                      }
                      return ListTile(
                        leading: const Padding(
                          padding: EdgeInsets.only(top: 8),
                          child: Icon(Icons.code_rounded),
                        ),
                        title: const Text('GitHub Repository'),
                        subtitle: Text(info),
                        onTap: () => openLink(
                          'https://github.com/raxysstudios/avzag',
                        ),
                      );
                    },
                  ),
                  SwitchListTile(
                    title: const Text('Editor Mode'),
                    subtitle: Row(
                      children: [
                        if (EditorStore.isEditing) ...[
                          if (EditorStore.isAdmin)
                            const SpanIcon(Icons.account_circle_rounded),
                          Text(capitalize(EditorStore.language)),
                        ] else
                          const Text('Off')
                      ],
                    ),
                    value: EditorStore.language != null,
                    secondary: const Padding(
                      padding: EdgeInsets.only(top: 8),
                      child: Icon(Icons.edit_rounded),
                    ),
                    onChanged: (e) => Navigator.push<void>(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AccountScreen(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            ColumnCard(
              divider: null,
              margin: EdgeInsets.zero,
              children: [
                _NavModule(
                  Icons.home_rounded,
                  'home',
                ).build(context, title),
                _NavModule(
                  Icons.book_rounded,
                  'dictionary',
                ).build(context, title),
                ...[
                  _NavModule(Icons.music_note_rounded, 'phonology'),
                  _NavModule(Icons.switch_left_rounded, 'converter'),
                  _NavModule(Icons.forum_rounded, 'phrasebook'),
                  _NavModule(Icons.local_library_rounded, 'bootcamp'),
                ].map((t) => t.build(context)),
              ],
            )
          ],
        ),
      ),
    );
  }
}
