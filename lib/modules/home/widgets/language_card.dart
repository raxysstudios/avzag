import 'package:avzag/models/language.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/utils.dart';
import 'package:avzag/shared/widgets/language_flag.dart';
import 'package:avzag/shared/widgets/span_icon.dart';
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
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedOpacity(
                opacity: selected ? 1 : .5,
                duration: duration200,
                child: LanguageFlag(
                  language.name,
                  offset: const Offset(20, 0),
                ),
              ),
            ],
          ),
          selected: selected,
          minVerticalPadding: 16,
          title: Text(
            language.endonym.titled,
            style: GoogleFonts.bitter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                language.name.titled,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              if (language.dictionary > 0)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: RichText(
                    overflow: TextOverflow.ellipsis,
                    text: TextSpan(
                      style: Theme.of(context).textTheme.caption?.copyWith(
                            fontSize: 14,
                          ),
                      children: [
                        const WidgetSpan(
                          child: SpanIcon(Icons.book_outlined),
                        ),
                        TextSpan(
                          text: language.dictionary.toString(),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
