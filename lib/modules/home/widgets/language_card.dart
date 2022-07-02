import 'package:avzag/models/language.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/widgets/language_flag.dart';
import 'package:avzag/shared/widgets/span_icon.dart';
import 'package:flutter/material.dart';

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
                duration: const Duration(milliseconds: 250),
                child: LanguageFlag(
                  language.name,
                  url: language.flag,
                  height: 4,
                  width: 12,
                  scale: 12,
                ),
              ),
            ],
          ),
          selected: selected,
          minVerticalPadding: 16,
          title: Text(
            language.endonym.titled,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                language.name.titled,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              if (language.stats != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
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
                          text: language.stats!.dictionary.toString(),
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
