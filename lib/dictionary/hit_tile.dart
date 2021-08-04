import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';

class EntryHit {
  final String entryID;
  final String headword;
  final String language;
  final String term;
  final String? definition;
  final List<String>? tags;

  const EntryHit({
    required this.entryID,
    required this.headword,
    required this.language,
    required this.term,
    this.tags,
    this.definition,
  });

  EntryHit.fromAlgoliaHitData(Map<String, dynamic> json)
      : this(
          entryID: json['entryID'],
          headword: json['headword'],
          language: json['language'],
          term: json['term'],
          definition: json['definition'],
          tags: json2list(json['tags'])?.map((t) => t.substring(1)).toList(),
        );
}

class HitTile extends StatelessWidget {
  final EntryHit hit;
  final void Function()? onTap;

  const HitTile(
    this.hit, {
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            capitalize(hit.headword),
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          Text(
            capitalize(hit.language),
            style: TextStyle(
              color: Colors.black54,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
      subtitle: RichText(
        maxLines: 1,
        text: TextSpan(
          style: TextStyle(
            fontSize: 14,
            color: Colors.black54,
          ),
          children: [
            WidgetSpan(
              child: Padding(
                padding: const EdgeInsets.only(right: 2),
                child: const Icon(
                  Icons.lightbulb_outline,
                  size: 16,
                  color: Colors.black54,
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
                  child: const Icon(
                    Icons.tag_outlined,
                    size: 16,
                    color: Colors.black54,
                  ),
                ),
              ),
              TextSpan(
                text: prettyTags(
                  hit.tags!,
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
