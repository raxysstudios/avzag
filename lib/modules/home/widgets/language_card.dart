import 'package:avzag/models/language.dart';
import 'package:avzag/shared/utils/utils.dart';
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
      shape: const RoundedRectangleBorder(),
      margin: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            AnimatedOpacity(
              opacity: selected ? 1 : 0.5,
              duration: const Duration(milliseconds: 250),
              child: Align(
                alignment: Alignment.centerRight,
                child: LanguageFlag(
                  language.flag,
                  height: 32,
                  width: 96,
                  scale: 2,
                  offset: const Offset(-16, 18),
                ),
              ),
            ),
            ListTile(
              selected: selected,
              minVerticalPadding: 16,
              title: Text(
                capitalize(language.name),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              subtitle: language.stats == null
                  ? null
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RichText(
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          text: TextSpan(
                            style:
                                Theme.of(context).textTheme.caption?.copyWith(
                                      fontSize: 14,
                                    ),
                            children: [
                              const WidgetSpan(
                                child: SpanIcon(Icons.book_rounded),
                              ),
                              TextSpan(
                                text: language.stats!.dictionary.toString(),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
