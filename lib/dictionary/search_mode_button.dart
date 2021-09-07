import 'package:avzag/global_store.dart';
import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/utils.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';

class SearchModeButton extends StatelessWidget {
  final String selected;
  final bool restricted;

  final Function(String language, bool restricted) onSelected;

  const SearchModeButton({
    required this.selected,
    required this.restricted,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;
    return Badge(
      showBadge: restricted,
      badgeColor: theme.primary,
      badgeContent: Icon(
        Icons.layers_outlined,
        size: 16,
        color: theme.onPrimary,
      ),
      child: PopupMenuButton(
        icon: selected.isEmpty
            ? Icon(Icons.language_outlined)
            : LanguageAvatar(
                GlobalStore.languages[selected]!.flag,
              ),
        tooltip: 'Select search mode',
        itemBuilder: (BuildContext context) {
          return [
            if (GlobalStore.languages.length > 1)
              buildOption(
                context,
                '',
                leading: const Icon(Icons.language_outlined),
                text: 'multilingual',
              ),
            for (final l in GlobalStore.languages.values)
              buildOption(
                context,
                l.name,
                leading: LanguageAvatar(l.flag),
              ),
          ];
        },
      ),
    );
  }

  PopupMenuItem buildOption(
    BuildContext context,
    String value, {
    Widget? leading,
    String? text,
  }) {
    return PopupMenuItem(
      padding: EdgeInsets.zero,
      child: ListTile(
        contentPadding: const EdgeInsets.only(
          left: 24,
          right: 16,
        ),
        leading: leading,
        title: Text(
          capitalize(text ?? value),
          softWrap: false,
          overflow: TextOverflow.fade,
          style: value.isEmpty
              ? null
              : const TextStyle(
                  fontWeight: FontWeight.w500,
                ),
        ),
        trailing: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
            onSelected('', true);
          },
          icon: const Icon(Icons.layers_outlined),
          color: selected != value || !restricted
              ? Theme.of(context).colorScheme.onSurface
              : null,
        ),
        onTap: () {
          Navigator.of(context).pop();
          onSelected(value, false);
        },
        selected: selected == value,
      ),
    );
  }
}
