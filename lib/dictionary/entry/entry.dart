import 'package:avzag/dictionary/sample/sample.dart';
import 'package:avzag/dictionary/use/use.dart';
import 'package:avzag/utils.dart';

class Entry {
  List<Sample> forms;
  List<String>? tags;
  String? note;
  List<Use> uses;

  Entry({
    required this.forms,
    required this.uses,
    this.tags,
    this.note,
  });

  Entry.fromJson(Map<String, dynamic> json)
      : this(
          forms: listFromJson(json['forms'], (j) => Sample.fromJson(j))!,
          uses: listFromJson(json['uses'], (j) => Use.fromJson(j))!,
          tags: json2list(json['tags']),
          note: json['note'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forms'] = forms.map((v) => v.toJson()).toList();
    if (tags?.isNotEmpty ?? false) data['tags'] = tags;
    if (note?.isNotEmpty ?? false) data['note'] = note;
    data['uses'] = uses.map((v) => v.toJson()).toList();
    return data;
  }
}
