import 'package:auto_route/auto_route.dart';
import 'package:avzag/modules/navigation/widgets/github_tile.dart';
import 'package:avzag/modules/navigation/widgets/module_tile.dart';
import 'package:avzag/modules/navigation/widgets/stores_buttons.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/utils.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/expandable_tile.dart';
import 'package:avzag/shared/widgets/raxys.dart';
import 'package:avzag/shared/widgets/span_icon.dart';
import 'package:avzag/store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../services/modules.dart';
import '../services/router.gr.dart';

class NavigationScreen extends StatelessWidget {
  const NavigationScreen({Key? key}) : super(key: key);

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
                  scale: 7,
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
                    leading: const Icon(Icons.send_outlined),
                    title: const Text('Developer Contact'),
                    subtitle: const Text('Raxys Studios'),
                    onTap: () => openLink('https://t.me/raxysstudios'),
                  ),
                  const GitHubTile(),
                  SwitchListTile(
                    title: const Text('Editor Mode'),
                    subtitle: EditorStore.editor
                        ? Row(
                            children: [
                              if (EditorStore.admin)
                                const SpanIcon(Icons.account_circle_outlined),
                              Text(EditorStore.language!.titled),
                            ],
                          )
                        : null,
                    value: EditorStore.editor,
                    secondary: const Icon(Icons.edit_outlined),
                    onChanged: (e) => context.pushRoute(const AccountRoute()),
                  ),
                  if (kIsWeb) ...[
                    const Divider(),
                    const StoresButtons(),
                  ],
                ],
              ),
            ),
            ColumnCard(
              divider: null,
              margin: EdgeInsets.zero,
              children: [
                for (final m in modules) ModuleTile(m),
              ],
            )
          ],
        ),
      ),
    );
  }
}
