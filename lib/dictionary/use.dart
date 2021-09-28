import 'package:avzag/utils.dart';
import 'package:avzag/widgets/text_sample_tiles.dart';

class Use {
  String term;
  String? definition;
  List<String>? tags;
  String? note;
  List<TextSample>? samples;

  Use({
    required this.term,
    this.definition,
    this.tags,
    this.note,
    this.samples,
  });

  Use.fromJson(Map<String, dynamic> json)
      : this(
          term: json['term'],
          definition: json['definition'],
          tags: json2list(json['tags']),
          note: json['note'],
          samples: listFromJson(
            json['samples'],
            (j) => TextSample.fromJson(j),
          ),
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['term'] = term;
    if (definition?.isNotEmpty ?? false) data['definition'] = definition;
    if (tags?.isNotEmpty ?? false) data['tags'] = tags;
    if (note?.isNotEmpty ?? false) data['note'] = note;
    if (samples?.isNotEmpty ?? false) {
      data['samples'] = samples!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
