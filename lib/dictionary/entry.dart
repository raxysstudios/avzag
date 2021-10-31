import 'package:avzag/widgets/text_sample_tiles.dart';
import 'package:avzag/dictionary/use.dart';
import 'package:avzag/utils.dart';

class Entry {
  List<TextSample> forms;
  String language;
  List<String>? tags;
  String? note;
  List<Use> uses;

  Entry({
    required this.forms,
    required this.language,
    required this.uses,
    this.tags,
    this.note,
  });

  Entry.fromJson(Map<String, dynamic> json)
      : this(
          forms: listFromJson(json['forms'], (j) => TextSample.fromJson(j))!,
          language: json['language'],
          uses: listFromJson(json['uses'], (j) => Use.fromJson(j))!,
          tags: json2list(json['tags']),
          note: json['note'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['forms'] = forms.map((v) => v.toJson()).toList();
    data['language'] = language;
    if (tags?.isNotEmpty ?? false) data['tags'] = tags;
    if (note?.isNotEmpty ?? false) data['note'] = note;
    data['uses'] = uses.map((v) => v.toJson()).toList();
    return data;
  }
}
