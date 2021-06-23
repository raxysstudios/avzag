import 'package:avzag/utils.dart';

import '../sample.dart';

class Phoneme {
  final String ipa;
  final String? note;
  final List<Sample>? samples;

  const Phoneme({
    required this.ipa,
    this.note,
    this.samples,
  });

  Phoneme.fromJson(Map<String, dynamic> json)
      : this(
          ipa: json['ipa'],
          note: json['note'],
          samples: listFromJson(json['samples'], (j) => Sample.fromJson(j)),
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['ipa'] = ipa;
    if (note?.isNotEmpty ?? false) data['note'] = note;
    if (samples != null)
      data['samples'] = samples!.map((v) => v.toJson()).toList();
    return data;
  }
}
