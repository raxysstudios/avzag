import 'package:avzag/dictionary/sample/sample.dart';
import 'package:avzag/dictionary/use/use.dart';
import 'package:avzag/utils.dart';

class Entry {
  String id;
  List<Sample> forms;
  List<Use>? uses;
  List<String>? tags;
  String? note;

  Entry({
    required this.id,
    required this.forms,
    this.uses,
    this.tags,
    this.note,
  });

  Entry.fromJson(
    Map<String, dynamic> json, {
    required String id,
  }) : this(
          id: id,
          forms: listFromJson(json['forms'], (j) => Sample.fromJson(j))!,
          uses: listFromJson(json['uses'], (j) => Use.fromJson(j)),
          tags: json2list(json['tags']),
          note: json['note'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forms'] = forms.map((v) => v.toJson()).toList();
    if (uses != null) data['uses'] = uses!.map((v) => v.toJson()).toList();
    if (tags != null) data['tags'] = tags;
    if (note?.isNotEmpty ?? false) data['note'] = note;
    return data;
  }
}
