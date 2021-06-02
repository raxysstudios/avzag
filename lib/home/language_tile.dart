import 'package:avzag/home/models.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'language_avatar.dart';

class LanguageTile extends StatelessWidget {
  final Language language;
  final bool selected;
  final void Function()? onTap;

  const LanguageTile(this.language, {this.selected = false, this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: LanguageAvatar(language),
      title: Text(
        capitalize(language.name),
        style: TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      selected: selected,
      onTap: onTap,
    );
  }
}
