class Sample {
  final String letter;
  final String word;
  final String? ipa;
  String? audioUrl;

  Sample({
    required this.letter,
    required this.word,
    this.ipa,
  });

  Sample.fromJson(Map<String, dynamic> json)
      : this(
          letter: json['letter'],
          word: json['word'],
          ipa: json['ipa'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['letter'] = letter;
    data['word'] = word;
    if (ipa?.isNotEmpty ?? false) data['ipa'] = ipa;
    return data;
  }
}
