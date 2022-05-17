import 'package:avzag/utils/utils.dart';
import 'package:avzag/widgets/text_sample_tiles.dart';

class Use {
  String term;
  List<String>? aliases;
  List<String>? tags;
  String? note;
  List<TextSample>? samples;

  Use({
    required this.term,
    this.aliases,
    this.tags,
    this.note,
    this.samples,
  });

  Use.fromJson(Map<String, dynamic> json)
      : this(
          term: json['term'] as String,
          aliases: json2list(json['aliases']),
          tags: json2list(json['tags']),
          note: json['note'] as String?,
          samples: listFromJson(
            json['samples'],
            (dynamic j) => TextSample.fromJson(j as Map<String, dynamic>),
          ),
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['term'] = term;
    if (aliases?.isNotEmpty ?? false) data['aliases'] = aliases;
    if (tags?.isNotEmpty ?? false) data['tags'] = tags;
    if (note?.isNotEmpty ?? false) data['note'] = note;
    if (samples?.isNotEmpty ?? false) {
      data['samples'] = samples!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
