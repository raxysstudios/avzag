class EntryHit {
  final String entryID;
  final String headword;
  final String language;
  final String term;
  final String? definition;

  const EntryHit({
    required this.entryID,
    required this.headword,
    required this.language,
    required this.term,
    this.definition,
  });

  EntryHit.fromAlgoliaHitData(Map<String, dynamic> json)
      : this(
          entryID: json['entryID'],
          headword: json['headword'],
          language: json['language'],
          term: json['term'],
          definition: json['definition'],
        );
}
