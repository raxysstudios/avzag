import 'dart:async';

import 'package:bazur/models/language.dart';
import 'package:bazur/shared/extensions.dart';
import 'package:bazur/shared/utils.dart';
import 'package:bazur/shared/widgets/column_card.dart';
import 'package:bazur/shared/widgets/language_avatar.dart';
import 'package:bazur/shared/widgets/span_icon.dart';
import 'package:bazur/store.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  var languages = <Language>[];
  var loading = false;

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
    if (EditorStore.user == null) {
      setState(() {
        languages.clear();
        adminable.clear();
      });
    } else {
      setState(() {
        loading = true;
      });
      for (final l in GlobalStore.languages) {
        await FirebaseFirestore.instance
            .doc('languages/$l')
            .withConverter(
              fromFirestore: (snapshot, _) =>
                  Language.fromJson(snapshot.data()!),
              toFirestore: (_, __) => {},
            )
            .get()
            .then((d) {
          final l = d.data();
          if (l != null) languages.add(l);
        });
      }
      adminable = await EditorStore.getAdminable();
    }
    setState(() {
      loading = false;
    });
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
        if (loading) const LinearProgressIndicator(),
        if (languages.isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(8),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final l in languages)
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
