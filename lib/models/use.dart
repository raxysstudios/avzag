import 'package:bazur/shared/utils.dart';

import 'sample.dart';

class Use {
  String term;
  List<String> aliases;
  List<String> tags;
  String? note;
  List<Sample> examples;

  Use(
    this.term, {
    required this.aliases,
    required this.tags,
    this.note,
    required this.examples,
  });

  Use.fromJson(Map<String, dynamic> json)
      : this(
          json['term'] as String,
          aliases: json2list(json['aliases']) ?? [],
          tags: json2list(json['tags']) ?? [],
          note: json['note'] as String?,
          examples: listFromJson(
                json['examples'],
                (dynamic j) => Sample.fromJson(j as Map<String, dynamic>),
              ) ??
              [],
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['term'] = term;
    if (aliases.isNotEmpty) data['aliases'] = aliases;
    if (tags.isNotEmpty) data['tags'] = tags;
    if (note?.isNotEmpty ?? false) data['note'] = note;
    if (examples.isNotEmpty) {
      data['examples'] = examples.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
