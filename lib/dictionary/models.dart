import 'package:avzag/utils.dart';

class Entry {
  List<Sample> forms;
  List<Use>? uses;
  List<String>? tags;
  List<String>? notes;

  Entry({required this.forms, this.uses, this.tags, this.notes});

  Entry.fromJson(Map<String, dynamic> json)
      : this(
          forms: listFromJson(json['forms'], (j) => Sample.fromJson(j))!,
          uses: listFromJson(json['uses'], (j) => Use.fromJson(j)),
          tags: json2list(json['tags']),
          notes: json2list(json['notes']),
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['forms'] = this.forms.map((v) => v.toJson()).toList();
    if (uses != null) data['uses'] = this.uses!.map((v) => v.toJson()).toList();
    if (tags != null) data['tags'] = tags;
    if (notes != null) data['notes'] = notes;
    return data;
  }
}

class Use {
  String meaning;
  List<String>? tags;
  List<Sample>? samples;

  Use({required this.meaning, this.tags, this.samples});

  Use.fromJson(Map<String, dynamic> json)
      : this(
          meaning: json['meaning'],
          tags: json2list(json['tags']),
          samples: listFromJson(json['samples'], (j) => Sample.fromJson(j)),
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['meaning'] = meaning;
    if (tags != null) data['tags'] = tags;
    if (samples != null)
      data['samples'] = samples!.map((v) => v.toJson()).toList();
    return data;
  }
}

class Sample {
  String plain;
  String? ipa;
  String? glossed;
  String? translation;

  Sample({required this.plain, this.ipa, this.glossed, this.translation});

  Sample.fromJson(Map<String, dynamic> json)
      : this(
          plain: json['plain'],
          ipa: json['ipa'],
          glossed: json['glossed'],
          translation: json['translation'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['plain'] = plain;
    if (ipa != null) data['ipa'] = ipa;
    if (glossed != null) data['glossed'] = ipa;
    if (translation != null) data['translation'] = ipa;
    return data;
  }
}
