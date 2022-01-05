import 'package:avzag/utils/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LanguageStats {
  final int dictionary;

  LanguageStats({
    this.dictionary = 0,
  });

  LanguageStats.fromJson(Map<String, Object?> json)
      : this(
          dictionary: json['dictionary'] as int,
        );

  Map<String, Object?> toJson() => {
        'dictionary': dictionary,
      };
}

class Language {
  final String name;
  final String? flag;
  final String? contact;
  final List<String>? family;
  final List<String>? tags;
  final GeoPoint? location;
  final LanguageStats? stats;

  const Language({
    required this.name,
    this.flag,
    this.contact,
    this.tags,
    this.family,
    this.location,
    this.stats,
  });

  Language.fromJson(Map<String, Object?> json)
      : this(
          name: json['name'] as String,
          flag: json['flag'] as String,
          contact: json['contact'] as String?,
          family: json2list(json['family']),
          tags: json2list(json['tags']),
          location:
              json['location'] == null ? null : json['location'] as GeoPoint,
          stats: json['stats'] == null
              ? null
              : LanguageStats.fromJson(json['stats'] as Map<String, Object?>),
        );

  Map<String, Object?> toJson() {
    final data = <String, dynamic>{};
    data['name'] = name;
    if (data['flag'] != null) data['flag'] = flag;
    if (contact?.isNotEmpty ?? false) data['contact'] = contact;
    if (family?.isNotEmpty ?? false) data['family'] = family;
    if (tags?.isNotEmpty ?? false) data['tags'] = tags;
    if (location != null) data['location'] = location;
    if (stats != null) data['stats'] = stats!.toJson();
    return data;
  }
}
