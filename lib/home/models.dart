// import 'package:latlong/latlong.dart';
import '../utils.dart';

class Language {
  final String name;
  final String? flag;
  // final LatLng? location;
  final List<String>? family;
  final List<String>? tags;

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

  Map<String, Object?> toJson() {
    final Map<String, dynamic> data = {};
    data['name'] = name;
    if (flag != null) data['flag'] = flag;
    if (family != null) data['family'] = family;
    if (tags != null) data['tags'] = tags;
    return data;
  }
}
