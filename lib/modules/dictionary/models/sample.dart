class Sample {
  String text;
  String? meaning;

  Sample(
    this.text, {
    this.meaning,
  });

  Sample.fromJson(Map<String, dynamic> json)
      : this(
          json['plain'] as String,
          meaning: json['translation'] as String?,
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['plain'] = text;
    if (meaning?.isNotEmpty ?? false) data['translation'] = meaning;
    return data;
  }
}
