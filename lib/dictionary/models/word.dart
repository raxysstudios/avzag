import 'package:avzag/dictionary/models/use.dart';
import 'package:avzag/utils/contribution.dart';
import 'package:avzag/utils/utils.dart';
import 'package:avzag/widgets/text_sample_tiles.dart';

class Word {
  String? id;
  List<TextSample> forms;
  String language;
  List<String>? tags;
  String? note;
  List<Use> uses;
  Contribution? contribution;

  Word({
    this.id,
    required this.forms,
    required this.language,
    required this.uses,
    this.contribution,
    this.tags,
    this.note,
  });

  Word.fromJson(
    Map<String, dynamic> json, [
    String? id,
  ]) : this(
          id: id,
          forms: listFromJson(
            json['forms'],
            (dynamic j) => TextSample.fromJson(j as Map<String, dynamic>),
          )!,
          language: json['language'] as String,
          uses: listFromJson(
            json['uses'],
            (dynamic j) => Use.fromJson(j as Map<String, dynamic>),
          )!,
          tags: json2list(json['tags']),
          note: json['note'] as String?,
          contribution: json['contribution'] == null
              ? null
              : Contribution.fromJson(
                  json['contribution'] as Map<String, dynamic>,
                ),
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['forms'] = forms.map((v) => v.toJson()).toList();
    data['language'] = language;
    if (tags?.isNotEmpty ?? false) data['tags'] = tags;
    if (note?.isNotEmpty ?? false) data['note'] = note;
    data['uses'] = uses.map((v) => v.toJson()).toList();
    if (contribution != null) data['contribution'] = contribution!.toJson();
    return data;
  }
}
