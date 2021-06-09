import 'package:avzag/dictionary/sample/sample.dart';
import 'package:avzag/utils.dart';

class Use {
  String concept;
  List<Sample>? samples;

  Use({required this.concept, this.samples});

  Use.fromJson(Map<String, dynamic> json)
      : this(
          concept: json['concept'],
          samples: listFromJson(json['samples'], (j) => Sample.fromJson(j)),
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['concept'] = concept;
    if (samples != null)
      data['samples'] = samples!.map((v) => v.toJson()).toList();
    return data;
  }
}
