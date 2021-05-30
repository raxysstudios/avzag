class SearchPreset {
  String title;
  String query;

  SearchPreset({required this.title, required this.query});

  SearchPreset.fromJson(Map<String, dynamic> json)
      : this(
          title: json['title'],
          query: json['query'],
        );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'query': query,
    };
  }
}
