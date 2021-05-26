import 'package:latlong/latlong.dart';

class Lect {
  Lect({required this.name, this.location, this.tags, this.family, this.flag});

  Lect.fromJson(Map<String, Object?> json)
      : this(
          name: json['name'] as String,
          flag: json['flag'] as String,
          location: json['location'] as LatLng,
          family: json['location'] as List<String>,
          tags: json['location'] as List<String>,
        );

  final String name;
  final String? flag;
  final LatLng? location;
  final List<String>? family;
  final List<String>? tags;

  Map<String, Object?> toJson() {
    return {
      'name': name,
      'flag': flag,
      'location': location,
      'family': family,
      'tags': tags
    };
  }
}
