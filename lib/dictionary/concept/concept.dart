import 'package:avzag/utils.dart';

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
