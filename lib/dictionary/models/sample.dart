class Sample {
  String plain;
  String? ipa;
  String? glossed;
  String? translation;

  Sample(
    this.plain, {
    this.ipa,
    this.glossed,
    this.translation,
  });

  Sample.fromJson(Map<String, dynamic> json)
      : this(
          json['plain'] as String,
          ipa: json['ipa'] as String?,
          glossed: json['glossed'] as String?,
          translation: json['translation'] as String?,
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['plain'] = plain;
    if (ipa?.isNotEmpty ?? false) data['ipa'] = ipa;
    if (glossed?.isNotEmpty ?? false) data['glossed'] = glossed;
    if (translation?.isNotEmpty ?? false) data['translation'] = translation;
    return data;
  }
}
