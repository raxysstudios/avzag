import 'package:avzag/home/language.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'language_avatar.dart';

class LanguageTile extends StatelessWidget {
  final Language language;
  final bool selected;
  final bool dense;
  final void Function()? onTap;

  const LanguageTile(
    this.language, {
    this.selected = false,
    this.dense = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: dense
          ? const VisualDensity(
              vertical: -4,
              horizontal: -4,
            )
          : null,
      leading: LanguageAvatar(language),
      title: Text(
        capitalize(language.name),
        style: TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      selected: selected,
      onTap: onTap,
    );
  }
}
