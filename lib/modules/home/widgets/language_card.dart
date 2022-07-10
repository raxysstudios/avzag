import 'package:avzag/models/language.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/utils.dart';
import 'package:avzag/shared/widgets/language_flag.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LanguageCard extends StatelessWidget {
  final Language language;
  final bool selected;
  final VoidCallback? onTap;

  const LanguageCard(
    this.language, {
    this.selected = false,
    this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        child: ListTile(
          selected: selected,
          minVerticalPadding: 16,
          title: Text(
            language.endonym.titled,
            style: GoogleFonts.bitter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            '${language.name.titled} • ${language.dictionary}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          trailing: Center(
            widthFactor: .4,
            child: AnimatedOpacity(
              opacity: selected ? 1 : .4,
              duration: duration200,
              child: LanguageFlag(language.name),
            ),
          ),
        ),
      ),
    );
  }
}
