import 'package:avzag/models/language.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/utils.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/language_avatar.dart';
import 'package:flutter/material.dart';

class AdminableLanguages extends StatelessWidget {
  const AdminableLanguages(
    this.languages, {
    required this.onTap,
    this.selected,
    Key? key,
  }) : super(key: key);

  final Iterable<Language> languages;
  final String? selected;
  final ValueSetter<String> onTap;

  @override
  Widget build(BuildContext context) {
    return ColumnCard(
      children: [
        for (final l in languages)
          ListTile(
            leading: LanguageAvatar(l.name),
            title: Text(
              l.name.titled,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
            onTap: () => onTap(l.name),
            selected: l.name == selected,
            trailing: Builder(
              builder: (context) {
                final contact = l.contact;
                return contact == null
                    ? const SizedBox()
                    : IconButton(
                        onPressed: () => openLink(contact),
                        icon: const Icon(Icons.send_outlined),
                        tooltip: 'Contact admin',
                      );
              },
            ),
          ),
      ],
    );
  }
}
