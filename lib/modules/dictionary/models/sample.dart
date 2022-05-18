class Sample {
  String text;
  String? meaning;

  Sample(
    this.text, {
    this.meaning,
  });

  Sample.fromJson(Map<String, dynamic> json)
      : this(
          json['text'] as String,
          meaning: json['meaning'] as String?,
        );

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    if (meaning?.isNotEmpty ?? false) data['meaning'] = meaning;
    return data;
  }
}
