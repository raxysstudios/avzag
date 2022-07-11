import 'package:bazur/shared/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Language {
  final String name;
  final String endonym;
  final String? contact;
  final List<String>? aliases;
  final GeoPoint? location;
  final int dictionary;

  const Language({
    required this.name,
    required this.endonym,
    this.contact,
    this.aliases,
    this.location,
    this.dictionary = 0,
  });

  Language.fromJson(Map<String, Object?> json)
      : this(
          name: json['name'] as String,
          endonym: json['endonym'] as String,
          contact: json['contact'] as String?,
          aliases: json2list(json['aliases']),
          location:
              json['location'] == null ? null : json['location'] as GeoPoint,
          dictionary: json['dictionary'] as int? ?? 0,
        );
}
