import 'package:avzag/home/language.dart';

import 'language_flag.dart';
import 'selectable_card.dart';
import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  const LanguageCard(this.language, {this.selected = false, this.onTap});
  final Language language;
  final bool selected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    print(language);
    return AspectRatio(
      aspectRatio: 3.5,
      child: SelectableCard(
        onTap: onTap,
        selected: selected,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: LanguageFlag(
              language,
              offset: Offset(-24, 0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(language.name),
          ),
        ],
      ),
    );
  }
}
