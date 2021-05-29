import 'package:avzag/utils.dart';
import 'sample/sample.dart';


class Use {
  String concept;
  List<Sample>? samples;
  String? note;

  Use({required this.concept, this.samples, this.note});

  Use.fromJson(Map<String, dynamic> json)
      : this(
          concept: json['concept'],
          samples: listFromJson(json['samples'], (j) => Sample.fromJson(j)),
          note: json['note'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['concept'] = concept;
    if (samples != null)
      data['samples'] = samples!.map((v) => v.toJson()).toList();
    if (note?.isNotEmpty ?? false) data['note'] = note;
    return data;
  }
}

class SearchPreset {
  String title;
  String query;

  SearchPreset({required this.title, required this.query});

  SearchPreset.fromJson(Map<String, dynamic> json)
      : this(
          title: json['title'],
          query: json['query'],
        );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'query': query,
    };
  }
}
