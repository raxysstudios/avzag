import 'package:avzag/utils.dart';

class Language {
  final String name;
  final String flag;
  final String? contact;
  final List<String>? editors;
  String? flagUrl;
  final List<String>? family;
  final List<String>? tags;

  Language({
    required this.name,
    required this.flag,
    this.editors,
    this.contact,
    this.tags,
    this.family,
  });

  Language.fromJson(Map<String, Object?> json)
      : this(
          name: json['name'] as String,
          flag: json['flag'] as String,
          contact: json['contact'] as String?,
          editors: json2list(json['editors']),
          family: json2list(json['family']),
          tags: json2list(json['tags']),
        );

  Map<String, Object?> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    data['flag'] = flag;
    if (contact?.isNotEmpty ?? false) data['contact'] = contact;
    if (editors?.isNotEmpty ?? false) data['editors'] = editors;
    if (family?.isNotEmpty ?? false) data['family'] = family;
    if (tags?.isNotEmpty ?? false) data['tags'] = tags;
    return data;
  }
}
