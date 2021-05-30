import 'package:avzag/dictionary/sample/sample.dart';
import 'package:avzag/utils.dart';

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
