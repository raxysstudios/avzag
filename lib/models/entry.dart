import 'package:algolia/algolia.dart';
import 'package:bazur/shared/utils.dart';

class Entry {
  final String entryID;
  final String objectID;
  final String headword;
  final String? form;
  final String language;
  final String translation;
  final bool unverified;
  final List<String>? tags;

  const Entry({
    required this.entryID,
    required this.objectID,
    required this.headword,
    this.form,
    required this.language,
    required this.translation,
    this.tags,
    this.unverified = false,
  });

  factory Entry.fromAlgoliaHit(AlgoliaObjectSnapshot hit) {
    final json = hit.data;

    final form = listFromJson(
          hit.highlightResult?['forms'],
          (dynamic i) => i['matchLevel'] != 'none',
        )?.indexOf(true) ??
        -1;

    return Entry(
      objectID: hit.objectID,
      entryID: json['entryID'] as String,
      headword: json['headword'] as String,
      form: form >= 0 ? json2list(json['forms'])![form] : null,
      language: json['language'] as String,
      translation: json['translation'] as String,
      unverified: json['unverified'] as bool? ?? false,
      tags: json2list(json['tags']),
    );
  }
}
