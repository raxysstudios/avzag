import 'package:auto_route/auto_route.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/utils.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/expandable_tile.dart';
import 'package:avzag/shared/widgets/raxys.dart';
import 'package:avzag/shared/widgets/span_icon.dart';
import 'package:avzag/store.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class _NavModule {
  const _NavModule(
    this.icon,
    this.text, [
    this.wip = false,
  ]);

  final IconData icon;
  final String text;
  final bool wip;
}

class NavDraver extends StatelessWidget {
  static const modules = [
    _NavModule(Icons.home_rounded, 'home'),
    _NavModule(Icons.book_rounded, 'dictionary'),
    _NavModule(Icons.music_note_rounded, 'phonology', true),
    _NavModule(Icons.switch_left_rounded, 'converter', true),
    _NavModule(Icons.forum_rounded, 'phrasebook', true),
    _NavModule(Icons.local_library_rounded, 'bootcamp', true),
  ];

  const NavDraver({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: ListView(
          children: [
            ExpandableTile(
              header: ListTile(
                leading: const Raxys(
                  opacity: .1,
                  scale: 9,
                ),
                title: Text(
                  'Ævzag',
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              body: ColumnCard(
                divider: null,
                margin: const EdgeInsets.only(bottom: 12),
                children: [
                  ListTile(
                    leading: const Icon(Icons.send_rounded),
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
                        info = 'v${package.version} • b${package.buildNumber}';
                      }
                      return ListTile(
                        leading: const Icon(Icons.code_rounded),
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
                    subtitle: EditorStore.editor
                        ? Row(
                            children: [
                              if (EditorStore.admin)
                                const SpanIcon(Icons.account_circle_rounded),
                              Text(EditorStore.language!.titled),
                            ],
                          )
                        : null,
                    value: EditorStore.editor,
                    secondary: const Icon(Icons.edit_rounded),
                    onChanged: (e) => context.navigateNamedTo('/account'),
                  ),
                ],
              ),
            ),
            ColumnCard(
              divider: null,
              margin: EdgeInsets.zero,
              children: [
                for (final m in modules)
                  ListTile(
                    leading: Icon(m.icon),
                    title: Text(
                      m.text.titled,
                      style: const TextStyle(fontSize: 18),
                    ),
                    trailing:
                        m.wip ? const Icon(Icons.construction_rounded) : null,
                    selected: context.router.current.name
                        .toLowerCase()
                        .startsWith(m.text),
                    onTap: () async {
                      if (m.text != 'home') {
                        await prefs.setString('module', m.text);
                      }
                      context.navigateNamedTo('/');
                    },
                    enabled: !m.wip,
                  ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
