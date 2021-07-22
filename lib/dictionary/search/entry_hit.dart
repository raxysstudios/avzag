class EntryHit {
  final String form;
  final String entryID;
  final String language;
  final String meaning;
  final String conceptID;

  const EntryHit({
    required this.form,
    required this.entryID,
    required this.language,
    required this.meaning,
    required this.conceptID,
  });

  EntryHit.fromAlgoliaHitData(Map<String, dynamic> json)
      : this(
          form: (json['forms'] as List<dynamic>).first,
          entryID: json['entryID'],
          meaning: json['meaning'],
          language: json['language'],
          conceptID: json['conceptID'],
        );
}

typedef EntryHitSearch = Map<String, List<EntryHit>>;
