import 'package:auto_route/auto_route.dart';
import 'package:avzag/modules/navigation/services/router.gr.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/utils.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/language_avatar.dart';
import 'package:avzag/shared/widgets/span_icon.dart';
import 'package:avzag/store.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

import '../widgets/sign_in_buttons.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({Key? key}) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  var adminable = <String>[];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Account'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.pushRoute(const RootRoute()),
        child: const Icon(Icons.done_all_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 76),
        children: [
          SignInButtons(
            onSignOut: () => setState(() {}),
            onSingIn: () => EditorStore.getAdminable().then(
              (value) => setState(() {
                adminable = value;
              }),
            ),
          ),
          if (EditorStore.user?.uid != null)
            ColumnCard(
              children: [
                for (final l in GlobalStore.languages.keys)
                  ListTile(
                    leading: Badge(
                      padding: EdgeInsets.zero,
                      ignorePointer: true,
                      badgeColor: theme.surface,
                      position: BadgePosition.topEnd(end: -20),
                      badgeContent: EditorStore.adminable.contains(l)
                          ? SpanIcon(
                              Icons.account_circle_rounded,
                              padding: const EdgeInsets.all(2),
                              color: theme.onSurface,
                            )
                          : null,
                      child: LanguageAvatar(l),
                    ),
                    title: Text(
                      l.titled,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    onTap: () => setState(() {
                      EditorStore.language =
                          l == EditorStore.language ? null : l;
                    }),
                    selected: l == EditorStore.language,
                    trailing: Builder(
                      builder: (context) {
                        final contact = GlobalStore.languages[l]?.contact;
                        return contact == null
                            ? const SizedBox()
                            : IconButton(
                                onPressed: () => openLink(contact),
                                icon: const Icon(Icons.send_rounded),
                                tooltip: 'Contact admin',
                              );
                      },
                    ),
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
