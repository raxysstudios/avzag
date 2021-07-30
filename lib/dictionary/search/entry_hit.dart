import 'package:avzag/utils.dart';

class EntryHit {
  final String entryID;
  final List<String> forms;
  final String language;
  final String term;
  final String? definition;
  final List<String>? tags;

  const EntryHit({
    required this.entryID,
    required this.forms,
    required this.language,
    required this.term,
    this.definition,
    this.tags,
  });

  EntryHit.fromAlgoliaHitData(Map<String, dynamic> json)
      : this(
          entryID: json['entryID'],
          forms: json2list(json['forms'])!,
          language: json['language'],
          term: json['term'],
          definition: json['definition'],
          tags: json2list(json['tags'])?.map((e) => e.substring(1)).toList(),
        );
}

typedef EntryHitSearch = Map<String, List<EntryHit>>;
