import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';

import 'hit_tile.dart';

class SearchController with ChangeNotifier {
  SearchController(
    this._languages,
    this._index, [
    this._onSearch,
  ]) {
    updateQuery();
  }

  final Iterable<String> _languages;
  final AlgoliaIndexReference _index;
  final VoidCallback? _onSearch;

  String _language = '';
  String get language => _language;
  set language(String value) {
    _language = value;
    updateQuery();
    notifyListeners();
  }

  bool _unverified = false;
  bool get unverified => _unverified;
  set unverified(bool value) {
    _unverified = value;
    updateQuery();
    notifyListeners();
  }

  bool get monolingual => language.isNotEmpty && language != '_';

  int get length => _tags.length;

  final Map<String, Set<String>> _tags = {};
  Set<String> getTags(String id) => _tags[id] ?? {};

  final Map<String, Map<String, List<EntryHit>>> _hits = {};
  List<List<EntryHit>> getHits(String id) {
    final hits = _hits[id] ?? {};
    final languages = _languages.where((l) => hits[l]!.isNotEmpty);
    return languages.map((l) => hits[l]!).toList();
  }

  late AlgoliaQuery _query = _index.query('');

  void updateQuery([String text = '']) {
    final parsed = _parseQuery(text);
    final languages = _generateFilter(
      monolingual ? [language] : _languages,
      'language',
    );
    _query = _index.query(parsed[0]).filters(
          parsed[1].isEmpty ? languages : '${parsed[1]} AND ($languages)',
        );
    if (unverified) {
      _query = _query.facetFilter('unverified:true');
    }
    _query = monolingual
        ? _query.setRestrictSearchableAttributes(['forms'])
        : _query.setHitsPerPage(50);

    _tags.clear();
    _hits.clear();
    _onSearch?.call();
  }

  Future<List<String>> fetchHits(int page) async {
    var hits = await _query.setPage(page).getObjects().then((s) => s.hits);
    if (hits.isNotEmpty && language == '_') {
      final original = {
        for (final hit in hits) hit.objectID: hit,
      };
      final terms = _generateFilter(
        hits.map((hit) => hit.data['term']),
        'term',
      );
      final languages = _generateFilter(_languages, 'language');
      hits = await _index
          .filters('($languages) AND ($terms)')
          .getObjects()
          .then((s) => s.hits.map((h) => original[h.objectID] ?? h))
          .then((h) => h.toList());
    }
    return _organizeHits(
      hits.map((h) => EntryHit.fromAlgoliaHit(h)),
    );
  }

  List<String> _organizeHits(Iterable<EntryHit> hits) {
    final newIds = <String>[];
    for (final hit in hits) {
      final id = monolingual ? hit.objectID : hit.term;
      _hits.putIfAbsent(id, () {
        _tags[id] = <String>{};
        newIds.add(id);
        return {for (final l in _languages) l: []};
      });
      _tags[id]?.addAll(hit.tags ?? []);
      _hits[id]?[hit.language]?.add(hit);
    }
    return newIds;
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
        if (e != '#') {
          tags.add(e.substring(1));
        }
      } else if (e.isNotEmpty) {
        words.add(e);
      }
    });
    return [
      words.join(' '),
      _generateFilter(tags, 'tags', true),
    ];
  }
}
