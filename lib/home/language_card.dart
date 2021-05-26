import 'package:avzag/home/language.dart';
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
      elevation: 0,
      margin: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(),
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: LanguageFlag(
                language,
                offset: Offset(-30, 36),
              ),
            ),
            ListTile(
              selected: selected,
              minVerticalPadding: 16,
              title: Text(
                capitalize(language.name),
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                capitalize(language.family?.join(' • ') ?? ''),
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                ),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       Text(
            //         capitalize(language.name),
            //         style: TextStyle(
            //           fontSize: 24,
            //           color: selected ? Colors.blue : Colors.black,
            //           fontWeight: FontWeight.bold,
            //         ),
            //       ),
            //       Text(
            //         capitalize(language.family?.join(' • ') ?? ''),
            //         style: TextStyle(
            //           fontSize: 14,
            //           color: Colors.black87,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
