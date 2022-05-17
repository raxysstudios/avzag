import 'package:avzag/global_store.dart';
import 'package:avzag/modules/navigation/sign_in_buttons.dart';
import 'package:avzag/shared/utils/open_link.dart';
import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/language_avatar.dart';
import 'package:avzag/shared/widgets/span_icon.dart';

import 'package:badges/badges.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'nav_drawer.dart';

class EditorModePage extends StatefulWidget {
  const EditorModePage({Key? key}) : super(key: key);

  @override
  State<EditorModePage> createState() => _EditorModePageState();
}

class _EditorModePageState extends State<EditorModePage> {
  List<String> editable = [];

  @override
  void initState() {
    super.initState();
    if (FirebaseAuth.instance.currentUser != null) {
      updateEditable();
    }
  }

  Future<void> updateEditable() async {
    final token =
        await FirebaseAuth.instance.currentUser?.getIdTokenResult(true);
    setState(() {
      editable = json2list(token?.claims?['admin']) ?? [];
    });
  }

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
        onPressed: () => navigate(context),
        tooltip: 'Continue',
        child: const Icon(Icons.done_all_rounded),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 76),
        children: [
          SignInButtons(
            onSignOut: () => setState(() {
              EditorStore.language = null;
              EditorStore.isAdmin = false;
              editable.clear();
            }),
            onSingIn: updateEditable,
          ),
          if (EditorStore.uid != null && GlobalStore.languages.isNotEmpty)
            ColumnCard(
              children: [
                for (final l in GlobalStore.languages.values)
                  Builder(
                    builder: (context) {
                      final editing = l.name == EditorStore.language;
                      final isAdmin = editable.contains(l.name);
                      return ListTile(
                        leading: Badge(
                          padding: EdgeInsets.zero,
                          ignorePointer: true,
                          badgeColor: theme.surface,
                          position: BadgePosition.topEnd(end: -20),
                          badgeContent: isAdmin
                              ? SpanIcon(
                                  Icons.account_circle_rounded,
                                  padding: const EdgeInsets.all(2),
                                  color: theme.onSurface,
                                )
                              : null,
                          child: LanguageAvatar(l.flag),
                        ),
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
                                onPressed: () => openLink(l.contact!),
                                icon: const Icon(Icons.send_rounded),
                                tooltip: 'Contact admin',
                              ),
                      );
                    },
                  ),
              ],
            ),
        ],
      ),
    );
  }
}
