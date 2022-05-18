import 'package:avzag/shared/utils/contribution.dart';
import 'package:avzag/shared/utils/utils.dart';

import 'sample.dart';
import 'use.dart';

class Word {
  String? id;
  String headword;
  String? ipa;
  List<Sample> forms;
  String language;
  List<String> tags;
  String? note;
  List<Use> uses;
  Contribution? contribution;

  Word({
    this.id,
    required this.headword,
    this.ipa,
    required this.language,
    required this.uses,
    required this.forms,
    required this.tags,
    this.contribution,
    this.note,
  });

  Word.fromJson(
    Map<String, dynamic> json, [
    String? id,
  ]) : this(
          id: id,
          // headword: json['headword'] as String,
          headword: listFromJson(
            json['forms'],
            (dynamic j) => Sample.fromJson(j as Map<String, dynamic>),
          )!
              .first
              .text,
          ipa: json['ipa'] as String?,
          forms: listFromJson(
                json['forms'],
                (dynamic j) => Sample.fromJson(j as Map<String, dynamic>),
              ) ??
              [],
          language: json['language'] as String,
          uses: listFromJson(
            json['uses'],
            (dynamic j) => Use.fromJson(j as Map<String, dynamic>),
          )!,
          tags: json2list(json['tags']) ?? [],
          note: json['note'] as String?,
          contribution: json['contribution'] == null
              ? null
              : Contribution.fromJson(
                  json['contribution'] as Map<String, dynamic>,
                ),
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['language'] = language;
    if (ipa != null) data['ipa'] = ipa;
    if (forms.isNotEmpty) data['forms'] = forms.map((v) => v.toJson()).toList();
    data['language'] = language;
    if (tags.isNotEmpty) data['tags'] = tags;
    if (note?.isNotEmpty ?? false) data['note'] = note;
    data['uses'] = uses.map((v) => v.toJson()).toList();
    if (contribution != null) data['contribution'] = contribution!.toJson();
    return data;
  }
}
