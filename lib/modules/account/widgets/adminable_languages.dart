import 'package:avzag/models/language.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/utils.dart';
import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/language_avatar.dart';
import 'package:avzag/shared/widgets/span_icon.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class AdminableLanguages extends StatelessWidget {
  const AdminableLanguages(
    this.languages, {
    required this.adminable,
    required this.onTap,
    this.selected,
    Key? key,
  }) : super(key: key);

  final List<Language> languages;
  final List<String> adminable;
  final String? selected;
  final ValueSetter<String> onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return ColumnCard(
      children: [
        for (final l in languages)
          ListTile(
            leading: Badge(
              padding: EdgeInsets.zero,
              ignorePointer: true,
              badgeColor: theme.surface,
              position: BadgePosition.topEnd(end: -20),
              badgeContent: adminable.contains(l.name)
                  ? SpanIcon(
                      Icons.account_circle_rounded,
                      padding: const EdgeInsets.all(2),
                      color: theme.onSurface,
                    )
                  : null,
              child: LanguageAvatar(l.name),
            ),
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
                        icon: const Icon(Icons.send_rounded),
                        tooltip: 'Contact admin',
                      );
              },
            ),
          ),
      ],
    );
  }
}
