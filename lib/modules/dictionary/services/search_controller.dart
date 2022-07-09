import 'package:algolia/algolia.dart';
import 'package:avzag/models/entry.dart';
import 'package:flutter/material.dart';

class SearchController with ChangeNotifier {
  SearchController(
    this._languages,
    this._index, [
    this._onSearch,
  ]) {
    updateQuery();
  }

  Iterable<String> _languages;

  final AlgoliaIndexReference _index;
  final VoidCallback? _onSearch;

  String _language = '';
  String get language => _language;

  bool _unverified = false;
  bool get unverified => _unverified;
  set unverified(bool value) {
    _unverified = value;
    updateQuery();
  }

  bool get monolingual => language.isNotEmpty && language != '_';

  int get length => _tags.length;

  AlgoliaQuerySnapshot? _snapshot;
  AlgoliaQuerySnapshot? get snapshot => _snapshot;

  final Map<String, Set<String>> _tags = {};
  Set<String> getTags(String id) => _tags[id] ?? {};

  final Map<String, Map<String, List<Entry>>> _hits = {};
  List<List<Entry>> getHits(String id) {
    final hits = _hits[id] ?? {};
    final languages = _languages.where((l) => hits[l]!.isNotEmpty);
    return languages.map((l) => hits[l]!).toList();
  }

  late AlgoliaQuery _query = _index.query('');

  void updateLanguage(String language, [Iterable<String>? languages]) {
    _language = language;
    _languages = languages ?? _languages;
    updateQuery();
  }

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
    notifyListeners();
  }

  Future<List<String>> fetchHits(int page) async {
    _snapshot = await _query.setPage(page).getObjects();
    notifyListeners();

    var hits = snapshot!.hits;
    if (hits.isNotEmpty && language == '_') {
      final original = {
        for (final hit in hits) hit.objectID: hit,
      };
      final terms = _generateFilter(
        hits.map((hit) => hit.data['term'] as String),
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
      hits.map((h) => Entry.fromAlgoliaHit(h)),
    );
  }

  List<String> _organizeHits(Iterable<Entry> hits) {
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
    String filter = 'tags',
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
