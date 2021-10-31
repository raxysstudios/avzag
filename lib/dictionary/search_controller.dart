import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';

import 'hit_tile.dart';

class SearchController with ChangeNotifier {
  SearchController(this._languages, this._index);
  final Iterable<String> _languages;
  final AlgoliaIndexReference _index;

  String _language = '';
  String get language => _language;
  set language(String value) {
    _language = value;
    notifyListeners();
  }

  bool _pendingOnly = false;
  bool get pendingOnly => _pendingOnly;
  set pendingOnly(bool value) {
    _pendingOnly = value;
    notifyListeners();
  }

  bool get monolingual => language.isNotEmpty && language != '_';

  int get length => _tags.length;

  final List<String> _ids = [];
  String getId(int i) => _ids[i];

  final Map<String, Set<String>> _tags = {};
  Set<String> getTags(int i) => _tags[getId(i)]!;

  final Map<String, Map<String, List<EntryHit>>> _hits = {};
  List<List<EntryHit>> getHits(int i) {
    var hits = _hits[getId(i)]!;
    var languages = _languages.where((l) => hits[l]!.isNotEmpty);
    return languages.map((l) => hits[l]!).toList();
  }

  bool _processing = false;
  bool get processing => _processing;

  void search([String text = ""]) async {
    _processing = true;
    notifyListeners();

    final parsed = _parseQuery(text);
    final languages = _generateFilter(
      monolingual ? [language] : _languages,
      'language',
    );
    var query = _index.query(parsed[0]).filters(
          parsed[1].isEmpty ? languages : '${parsed[1]} AND ($languages)',
        );
    if (pendingOnly) query = query.facetFilter('pendingReview:true');
    if (monolingual) query = query.setRestrictSearchableAttributes(['forms']);

    _organizeHits(await _fetchHits(query));
    _processing = false;
    notifyListeners();
  }

  Future<Iterable<EntryHit>> _fetchHits(AlgoliaQuery query) async {
    var hits = await query
        .getObjects()
        .then((s) => s.hits)
        .onError((error, stackTrace) => []);

    if (language == '_') {
      final terms = _generateFilter(
        hits.map((hit) => hit.data['term']),
        'term',
      );
      final original = {
        for (final hit in hits) hit.objectID: hit,
      };
      hits = await _index
          .filters('($_languages) AND ($terms)')
          .getObjects()
          .then((s) => s.hits.map((h) => original[h.objectID] ?? h))
          .then((h) => h.toList())
          .onError((error, stackTrace) => []);
    }
    return hits.map((h) => EntryHit.fromAlgoliaHit(h));
  }

  _organizeHits(Iterable<EntryHit> hits) {
    _ids.clear();
    _tags.clear();
    _hits.clear();
    for (final hit in hits) {
      var id = hit.term;
      if (hit.definition != null) id += ' ' + hit.definition!;
      _hits.putIfAbsent(id, () {
        _tags[id] = <String>{};
        _ids.add(id);
        return {for (final l in _languages) l: <EntryHit>[]};
      });
      _tags[id]!.addAll(hit.tags ?? []);
      _hits[id]![hit.language]!.add(hit);
    }
  }

  static String _generateFilter(
    Iterable<String> values, [
    filter = 'tags',
    bool and = false,
  ]) {
    final joint = and ? 'AND' : 'OR';
    final tags = values.map((v) => '$filter:"$v"');
    return tags.join(' $joint ');
  }

  static List<String> _parseQuery(String query) {
    final tags = <String>[];
    final words = <String>[];
    query.split(' ').forEach((e) {
      if (e.startsWith('#')) {
        tags.add(e.substring(1));
      } else {
        words.add(e);
      }
    });
    return [
      words.join(' '),
      _generateFilter(tags, 'tags', true),
    ];
  }
}
