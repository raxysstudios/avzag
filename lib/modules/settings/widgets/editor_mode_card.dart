import 'dart:async';

import 'package:avzag/models/language.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/utils.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/language_avatar.dart';
import 'package:avzag/shared/widgets/span_icon.dart';
import 'package:avzag/store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditorModeCard extends StatefulWidget {
  const EditorModeCard({Key? key}) : super(key: key);

  @override
  State<EditorModeCard> createState() => _EditorModeCardState();
}

class _EditorModeCardState extends State<EditorModeCard> {
  late final StreamSubscription<User?> _authStream;
  var adminable = <String>[];

  @override
  void initState() {
    super.initState();
    _authStream = FirebaseAuth.instance.authStateChanges().listen(
          (_) => updateAdminable(),
        );
  }

  @override
  void dispose() {
    _authStream.cancel();
    super.dispose();
  }

  void updateAdminable() async {
    adminable = await EditorStore.getAdminable();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ColumnCard(
      margin: const EdgeInsets.symmetric(vertical: 12),
      children: [
        ListTile(
          leading: const Icon(Icons.edit_outlined),
          title: const Text('Editor mode'),
          subtitle: Row(
            children: [
              if (EditorStore.language == null)
                Text(
                  EditorStore.user == null
                      ? 'Sign in to contribute'
                      : 'Select language below',
                  style: const TextStyle(fontStyle: FontStyle.italic),
                )
              else ...[
                if (EditorStore.admin)
                  const SpanIcon(Icons.verified_user_outlined),
                Text(EditorStore.language!.titled),
              ]
            ],
          ),
        ),
        if (EditorStore.user != null)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final l
                    in GlobalStore.languages.values.whereType<Language>())
                  InputChip(
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    avatar: LanguageAvatar(l.name),
                    label: Text(l.name.titled),
                    onDeleted:
                        l.contact == null ? null : () => openLink(l.contact!),
                    deleteButtonTooltipMessage: 'Contact',
                    deleteIcon: const Icon(
                      Icons.help_outlined,
                      size: 18,
                    ),
                    tooltip: l.endonym.titled,
                    selected: l.name == EditorStore.language,
                    onSelected: (s) => setState(() {
                      EditorStore.language = s ? l.name : null;
                    }),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}
