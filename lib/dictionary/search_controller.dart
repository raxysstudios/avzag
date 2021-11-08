import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';

import 'hit_tile.dart';

class SearchController with ChangeNotifier {
  SearchController(
    this._languages,
    this._index, [
    this._onSearch,
  ]);
  final Iterable<String> _languages;
  final AlgoliaIndexReference _index;
  final VoidCallback? _onSearch;

  String _language = '';
  String get language => _language;
  set language(String value) {
    _language = value;
    notifyListeners();
  }

  bool _unverified = false;
  bool get unverified => _unverified;
  set unverified(bool value) {
    _unverified = value;
    notifyListeners();
  }

  bool get monolingual => language.isNotEmpty && language != '_';

  int get length => tags.length;

  final Map<String, Set<String>> tags = {};
  Set<String> getTags(String term) => tags[term] ?? {};

  final Map<String, Map<String, List<EntryHit>>> _hits = {};
  List<List<EntryHit>> getHits(String term) {
    final hits = _hits[term] ?? {};
    final languages = _languages.where((l) => hits[l]!.isNotEmpty);
    return languages.map((l) => hits[l]!).toList();
  }

  bool _processing = false;
  bool get processing => _processing;

  late AlgoliaQuery _query = _index.query('');

  void search([String text = ""]) {
    final parsed = _parseQuery(text);
    final languages = _generateFilter(
      monolingual ? [language] : _languages,
      'language',
    );
    _query = _index.query(parsed[0]).filters(
          parsed[1].isEmpty ? languages : '${parsed[1]} AND ($languages)',
        );
    if (unverified) _query = _query.facetFilter('unverified:true');
    if (monolingual) _query = _query.setRestrictSearchableAttributes(['forms']);

    _onSearch?.call();
    fetchHits();
  }

  Future fetchHits([int page = 0]) async {
    _processing = true;
    notifyListeners();

    var hits = await _query
        .setPage(page)
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

    tags.clear();
    _hits.clear();
    _organizeHits(hits.map((h) => EntryHit.fromAlgoliaHit(h)));
    _processing = false;
    notifyListeners();
  }

  _organizeHits(Iterable<EntryHit> hits) {
    for (final hit in hits) {
      final term = hit.term;
      _hits.putIfAbsent(term, () {
        tags[term] = <String>{};
        return {for (final l in _languages) l: []};
      });
      tags[term]?.addAll(hit.tags ?? []);
      _hits[term]?[hit.language]?.add(hit);
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
