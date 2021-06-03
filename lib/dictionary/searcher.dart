import 'entry/entry.dart';
import 'query_utils.dart';

class Searcher {
  Function setState;
  final Map<String, List<Entry>> dictionaries;
  final Map<String, double> progress = {};
  final Map<String, Map<String, List<Entry>>> results = {};

  Iterable<String> get languages => dictionaries.keys.toList();

  Function? pending;
  bool executing = false;
  bool get done => !executing && progress[''] == 1;

  Searcher(this.dictionaries, this.setState) {
    reset();
  }

  Future<void> sleep() {
    return Future.delayed(Duration(milliseconds: 10));
  }

  void reset() {
    setState(() {
      languages.forEach((l) => progress[l] = 0);
      progress[''] = 0;
      results.clear();
    });
  }

  void addResult(String lect, Iterable<String> meanings, Entry entry) {
    setState(() {
      for (final m in meanings) {
        if (results[m] == null) results[m] = {};
        if (results[m]![lect] == null) results[m]![lect] = [];
        results[m]![lect]!.add(entry);
      }
    });
  }

  void updateProgress(String key, double value) {
    setState(() {
      progress[key] = value;
    });
  }

  Future<void> queryDictionary(
    String lect,
    List<Entry> entries,
    Iterable<Iterable<String>> queries,
    bool forms,
    bool uses,
  ) async {
    for (int i = 0; i < entries.length; i++) {
      final meanings = checkQueries(entries[i], queries, forms, uses);
      if (meanings.isNotEmpty) addResult(lect, meanings, entries[i]);
      if (pending != null)
        return;
      else if (i % 1000 == 0) {
        updateProgress(lect, i / entries.length);
        await sleep();
      }
    }
    updateProgress(lect, 1);
  }

  Future<Iterable<Iterable<String>>> findMeanings(
    List<Entry> entries,
    Iterable<Iterable<String>> queries,
  ) async {
    final meanings = Set<String>();
    for (int i = 0; i < entries.length; i++) {
      checkQueries(entries[i], queries, true, false)
          .forEach((m) => meanings.add(m));
      if (pending != null)
        return [];
      else if (i % 1000 == 0) {
        updateProgress('', i / entries.length);
        await sleep();
      }
    }
    updateProgress('', 1);
    return meanings.map((m) => ['!' + m]);
  }

  Future<void> queue(Future<void> Function() action) async {
    final call = () async {
      pending = null;
      executing = true;
      await action();
      executing = false;
      if (pending != null) {
        final p = pending;
        pending = null;
        p!();
      }
    };
    if (executing)
      pending = call;
    else
      call();
  }

  stop() {
    queue(() => Future.sync(() => print("Searcher stopped")));
  }

  search(String lect, String query) {
    queue(() async {
      reset();
      var queries = parseQuery(query.toLowerCase());
      if (queries.isEmpty) return;
      if (languages.length == 1) {
        lect = languages.first;
        await queryDictionary(
          lect,
          dictionaries[lect]!,
          queries,
          true,
          true,
        );
        updateProgress('', 1);
        return;
      }

      if (queries.isNotEmpty) if (lect.isNotEmpty)
        queries = await findMeanings(dictionaries[lect]!, queries);
      if (queries.isNotEmpty)
        await Future.wait(
          dictionaries.entries.map(
            (d) => queryDictionary(
              d.key,
              d.value,
              queries,
              false,
              true,
            ),
          ),
        );
      updateProgress('', 1);
    });
  }
}
