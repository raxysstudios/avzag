import 'package:avzag/utils.dart';

import 'sample/sample.dart';

class Entry {
  List<Sample> forms;
  List<Use>? uses;
  List<String>? tags;
  String? note;

  Entry({required this.forms, this.uses, this.tags, this.note});

  Entry.fromJson(Map<String, dynamic> json)
      : this(
          forms: listFromJson(json['forms'], (j) => Sample.fromJson(j))!,
          uses: listFromJson(json['uses'], (j) => Use.fromJson(j)),
          tags: json2list(json['tags']),
          note: json['note'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forms'] = this.forms.map((v) => v.toJson()).toList();
    if (uses != null) data['uses'] = this.uses!.map((v) => v.toJson()).toList();
    if (tags != null) data['tags'] = tags;
    if (note?.isNotEmpty ?? false) data['note'] = note;
    return data;
  }
}

class Use {
  String concept;
  List<Sample>? samples;
  String? note;

  Use({required this.concept, this.samples, this.note});

  Use.fromJson(Map<String, dynamic> json)
      : this(
          concept: json['concept'],
          samples: listFromJson(json['samples'], (j) => Sample.fromJson(j)),
          note: json['note'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['concept'] = concept;
    if (samples != null)
      data['samples'] = samples!.map((v) => v.toJson()).toList();
    if (note?.isNotEmpty ?? false) data['note'] = note;
    return data;
  }
}

class Concept {
  String meaning;
  List<String>? tags;

  Concept({required this.meaning, required this.tags});

  Concept.fromJson(Map<String, dynamic> json)
      : this(
          meaning: json['meaning'],
          tags: json2list(json['tags']),
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['meaning'] = meaning;
    if (tags != null) data['tags'] = tags;
    return data;
  }
}

class SearchPreset {
  String title;
  String query;

  SearchPreset({required this.title, required this.query});

  SearchPreset.fromJson(Map<String, dynamic> json)
      : this(
          title: json['title'],
          query: json['query'],
        );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'query': query,
    };
  }
}
