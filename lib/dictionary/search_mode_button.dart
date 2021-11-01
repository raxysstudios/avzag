import 'package:avzag/global_store.dart';
import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/utils/utils.dart';

import 'package:flutter/material.dart';

class SearchModeButton extends StatelessWidget {
  final String language;
  final ValueSetter<String> onSelected;

  const SearchModeButton(
    this.language, {
    required this.onSelected,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: language.isEmpty
          ? const Icon(Icons.language_outlined)
          : language == '_'
              ? const Icon(Icons.layers_outlined)
              : LanguageAvatar(
                  GlobalStore.languages[language]!.flag,
                ),
      tooltip: 'Select search mode',
      itemBuilder: (BuildContext context) {
        return <PopupMenuEntry>[
          buildOption(
            context,
            '',
            leading: const Icon(Icons.language_outlined),
            text:
                GlobalStore.languages.length == 1 ? 'english' : 'multilingual',
          ),
          if (GlobalStore.languages.length > 1)
            buildOption(
              context,
              '_',
              leading: const Icon(Icons.layers_outlined),
              text: 'cross-lingual',
            ),
          const PopupMenuDivider(height: 0),
          for (final l in GlobalStore.languages.values)
            buildOption(
              context,
              l.name,
              leading: LanguageAvatar(l.flag),
            ),
        ];
      },
    );
  }

  PopupMenuItem buildOption(
    BuildContext context,
    String value, {
    Widget? leading,
    String? text,
  }) {
    return PopupMenuItem(
      onTap: () => onSelected(value),
      child: ListTile(
        leading: leading,
        title: Text(
          capitalize(text ?? value),
          softWrap: false,
          overflow: TextOverflow.fade,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        selected: language == value,
      ),
    );
  }
}
