import 'hit_tile.dart';

typedef SearchHitsMap = Map<String, Map<String, List<EntryHit>>>;

class SearchResults {
  final SearchHitsMap hits = {};
  final Map<String, Set<String>> tags = {};
  final List<String> ids = [];
  final Iterable<String> languages;

  int get length => tags.length;
  List<List<EntryHit>> operator [](int i) {
    var hits = this.hits[ids[i]]!;
    var languages = this.languages.where((l) => hits[l]!.isNotEmpty);
    return languages.map((l) => hits[l]!).toList();
  }

  SearchResults([
    List<EntryHit> hits = const [],
    this.languages = const [],
  ]) {
    for (final hit in hits) {
      var id = hit.term;
      if (hit.definition != null) id += ' ' + hit.definition!;
      this.hits.putIfAbsent(id, () {
        tags[id] = <String>{};
        ids.add(id);
        return {for (final l in languages) l: <EntryHit>[]};
      });
      tags[id]!.addAll(hit.tags ?? []);
      this.hits[id]![hit.language]!.add(hit);
    }
  }
}
