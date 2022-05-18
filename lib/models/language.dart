import 'package:avzag/shared/utils/utils.dart';
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
  final List<String>? aliases;
  final GeoPoint? location;
  final LanguageStats? stats;

  const Language({
    required this.name,
    this.flag,
    this.contact,
    this.aliases,
    this.location,
    this.stats,
  });

  Language.fromJson(Map<String, Object?> json)
      : this(
          name: json['name'] as String,
          flag: json['flag'] as String,
          contact: json['contact'] as String?,
          aliases: json2list(json['family']),
          location:
              json['location'] == null ? null : json['location'] as GeoPoint,
          stats: json['stats'] == null
              ? null
              : LanguageStats.fromJson(json['stats'] as Map<String, Object?>),
        );
}
