import 'package:algolia/algolia.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';

class EntryHit {
  final String entryID;
  final String headword;
  final String? form;
  final String language;
  final String term;
  final String? definition;
  final List<String>? tags;

  const EntryHit({
    required this.entryID,
    required this.headword,
    this.form,
    required this.language,
    required this.term,
    this.tags,
    this.definition,
  });

  factory EntryHit.fromAlgoliaHit(AlgoliaObjectSnapshot hit) {
    final json = hit.data;

    final form = listFromJson(
          hit.highlightResult?['forms'],
          (i) => i['matchLevel'] != 'none',
        )?.indexOf(true) ??
        -1;

    return EntryHit(
      entryID: json['entryID'],
      headword: json['headword'],
      form: form >= 0 ? json2list(json['forms'])![form] : null,
      language: json['language'],
      term: json['term'],
      definition: json['definition'],
      tags: json2list(json['tags'])?.map((t) => t.substring(1)).toList(),
    );
  }
}

class HitTile extends StatelessWidget {
  final EntryHit hit;
  final bool showLanguage;
  final VoidCallback? onTap;

  const HitTile(
    this.hit, {
    this.showLanguage = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RichText(
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            text: TextSpan(
              style: theme.subtitle1?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: capitalize(hit.headword),
                ),
                if (hit.form != null && hit.form != hit.headword) ...[
                  WidgetSpan(
                    child: SizedBox(width: 8),
                  ),
                  TextSpan(
                    text: capitalize(hit.form!),
                    style: TextStyle(
                      color: theme.caption?.color,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ]
              ],
            ),
          ),
          if (showLanguage)
            Text(
              capitalize(hit.language),
              style: theme.caption?.copyWith(
                fontWeight: FontWeight.w500,
              ),
            ),
        ],
      ),
      subtitle: RichText(
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: theme.caption?.copyWith(
            fontSize: 14,
          ),
          // style: TextStyle(
          //   fontSize: 14,
          //   color: Colors.black54,
          // ),
          children: [
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 2),
                child: Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: theme.caption?.color,
                ),
              ),
            ),
            TextSpan(
              text: capitalize(hit.term),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
            if (hit.definition != null)
              TextSpan(
                text: ' ' + hit.definition!,
              ),
            if (hit.tags?.isNotEmpty ?? false) ...[
              WidgetSpan(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8, right: 2),
                  child: Icon(
                    Icons.tag_outlined,
                    size: 16,
                    color: theme.caption?.color,
                  ),
                ),
              ),
              TextSpan(
                text: prettyTags(
                  hit.tags,
                  separator: ' ',
                  capitalized: false,
                )!,
              ),
            ]
          ],
        ),
      ),
      onTap: onTap,
    );
  }
}
