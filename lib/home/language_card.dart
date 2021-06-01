import 'package:avzag/home/models.dart';
import 'package:avzag/utils.dart';

import 'language_flag.dart';
import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  const LanguageCard(this.language, {this.selected = false, this.onTap});
  final Language language;
  final bool selected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      // color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: selected ? 1 : 0.4,
              duration: Duration(milliseconds: 250),
              child: Align(
                alignment: Alignment.centerRight,
                child: LanguageFlag(
                  language,
                  offset: Offset(-30, 36),
                ),
              ),
            ),
            ListTile(
              selected: selected,
              minVerticalPadding: 16,
              title: Text(
                capitalize(language.name),
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                capitalize(language.family?.join(' • ') ?? ''),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
