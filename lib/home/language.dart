import 'package:avzag/utils/utils.dart';

class LanguageStats {
  final int editors;
  final int dictionary;

  LanguageStats({
    this.editors = 0,
    this.dictionary = 0,
  });

  LanguageStats.fromJson(Map<String, Object?> json)
      : this(
          editors: json['editors'] as int,
          dictionary: json['dictionary'] as int,
        );

  Map<String, Object?> toJson() => {
        'editors': editors,
        'dictionary': dictionary,
      };
}

class Language {
  final String name;
  final String? flag;
  final String? contact;
  final List<String>? family;
  final List<String>? tags;
  final LanguageStats? stats;

  const Language({
    required this.name,
    this.flag,
    this.contact,
    this.tags,
    this.family,
    this.stats,
  });

  Language.fromJson(Map<String, Object?> json)
      : this(
          name: json['name'] as String,
          flag: json['flag'] as String,
          contact: json['contact'] as String?,
          family: json2list(json['family']),
          tags: json2list(json['tags']),
          stats: json['stats'] == null
              ? null
              : LanguageStats.fromJson(json['stats'] as Map<String, Object?>),
        );

  Map<String, Object?> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    if (data['flag'] != null) data['flag'] = flag;
    if (contact?.isNotEmpty ?? false) data['contact'] = contact;
    if (family?.isNotEmpty ?? false) data['family'] = family;
    if (tags?.isNotEmpty ?? false) data['tags'] = tags;
    if (stats != null) data['stats'] = stats!.toJson();
    return data;
  }
}
