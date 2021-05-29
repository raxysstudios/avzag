class Sample {
  String plain;
  String? ipa;
  String? glossed;
  String? translation;

  Sample({required this.plain, this.ipa, this.glossed, this.translation});

  Sample.fromJson(Map<String, dynamic> json)
      : this(
          plain: json['plain'],
          ipa: json['ipa'],
          glossed: json['glossed'],
          translation: json['translation'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['plain'] = plain;
    if (ipa?.isNotEmpty ?? false) data['ipa'] = ipa;
    if (glossed?.isNotEmpty ?? false) data['glossed'] = ipa;
    if (translation?.isNotEmpty ?? false) data['translation'] = ipa;
    return data;
  }
}
