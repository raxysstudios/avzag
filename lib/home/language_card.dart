import 'package:avzag/home/language.dart';
import 'package:avzag/utils.dart';
import 'language_flag.dart';
import 'package:flutter/material.dart';

class LanguageCard extends StatelessWidget {
  final Language language;
  final bool selected;
  final VoidCallback? onTap;

  const LanguageCard(
    this.language, {
    Key? key,
    this.selected = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            child: Stack(
              children: [
                AnimatedOpacity(
                  opacity: selected ? 0.8 : 0.4,
                  duration: const Duration(milliseconds: 250),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: LanguageFlag(
                      language.flag,
                      offset: const Offset(-30, 36),
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
                    subtitle: Theme(
                      data: ThemeData(
                        iconTheme: IconThemeData(
                          color: Theme.of(context).textTheme.caption?.color,
                          size: 16,
                        ),
                      ),
                      child: RichText(
                        maxLines: 2,
                        text: TextSpan(
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                          children: [
                            if (language.family?.isNotEmpty ?? false)
                              TextSpan(
                                text: prettyTags(language.family)!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            if (language.stats != null) ...[
                              if (language.family?.isNotEmpty ?? false)
                                const TextSpan(text: '\n'),
                              const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(right: 2),
                                  child: Icon(Icons.person_outlined),
                                ),
                              ),
                              TextSpan(
                                text: language.stats!.editors.toString(),
                              ),
                              const WidgetSpan(
                                child: Padding(
                                  padding: EdgeInsets.only(left: 8, right: 2),
                                  child: Icon(Icons.tag_outlined),
                                ),
                              ),
                              TextSpan(
                                text: language.stats!.dictionary.toString(),
                              ),
                            ]
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
