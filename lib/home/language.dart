// import 'package:latlong/latlong.dart';

List<T> json2list<T>(Object? array) {
  return (array as Iterable<dynamic>).map((i) => i as T).toList();
}

class Language {
  Language({
    required this.name,
    // this.location,
    this.tags,
    this.family,
    this.flag,
  });

  Language.fromJson(Map<String, Object?> json)
      : this(
          name: json['name'] as String,
          flag: json['flag'] as String,
          // location: json['location'] as LatLng,
          family: json2list<String>(json['family']),
          tags: json2list<String>(json['tags']),
        );

  final String name;
  final String? flag;
  // final LatLng? location;
  final List<String>? family;
  final List<String>? tags;

  Map<String, Object?> toJson() {
    return {
      name: name,
      'flag': flag,
      // 'location': location,
      'family': family,
      'tags': tags
    };
  }
}
