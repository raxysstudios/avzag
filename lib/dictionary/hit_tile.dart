import 'package:algolia/algolia.dart';
import 'package:avzag/utils/utils.dart';
import 'package:avzag/widgets/span_icon.dart';

import 'package:flutter/material.dart';

class EntryHit {
  final String entryID;
  final String objectID;
  final String headword;
  final String? form;
  final String language;
  final String term;
  final bool unverified;
  final List<String>? tags;

  const EntryHit({
    required this.entryID,
    required this.objectID,
    required this.headword,
    this.form,
    required this.language,
    required this.term,
    this.tags,
    this.unverified = false,
  });

  factory EntryHit.fromAlgoliaHit(AlgoliaObjectSnapshot hit) {
    final json = hit.data;

    final form = listFromJson(
          hit.highlightResult?['forms'],
          (i) => i['matchLevel'] != 'none',
        )?.indexOf(true) ??
        -1;

    return EntryHit(
      objectID: hit.objectID,
      entryID: json['entryID'],
      headword: json['headword'],
      form: form >= 0 ? json2list(json['forms'])![form] : null,
      language: json['language'],
      term: json['term'],
      unverified: json['unverified'] ?? false,
      tags: json2list(json['tags']),
    );
  }
}

class HitTile extends StatelessWidget {
  final EntryHit hit;
  final bool showLanguage;
  final VoidCallback? onTap;

  const HitTile(
    this.hit, {
    Key? key,
    this.showLanguage = true,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return ListTile(
      dense: true,
      title: Row(
        children: [
          if (hit.unverified)
            const SpanIcon(
              Icons.unpublished_rounded,
              padding: EdgeInsets.only(right: 4),
            ),
          Text(
            capitalize(hit.headword),
            style: theme.subtitle1?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
          if (hit.form != null && hit.form != hit.headword)
            Padding(
              padding: const EdgeInsets.only(left: 4),
              child: Text(
                capitalize(hit.form!),
                style: theme.subtitle1?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: theme.caption?.color,
                ),
              ),
            ),
          const Spacer(),
          if (showLanguage)
            Text(
              capitalize(hit.language),
              style: theme.caption,
            ),
        ],
      ),
      onTap: onTap,
    );
  }
}
