import 'package:avzag/dictionary/concept/concept.dart';
import 'package:avzag/dictionary/store.dart';

import 'entry/entry.dart';
import 'use/use.dart';

Concept getConcept(Use use) {
  return DictionaryStore.concepts[use.concept] ??
      Concept(
        meaning: "",
        tags: null,
      );
}

Iterable<Concept> checkTag(Entry entry, String tag) {
  tag = tag.substring(1);
  if (entry.tags?.contains(tag) ?? false) return entry.uses.map(getConcept);
  return entry.uses
      .map(getConcept)
      .where((c) => c.tags?.contains(tag) ?? false);
}

bool checkSegment(String area, String segment) {
  switch (segment[0]) {
    case "!":
      return area == segment.substring(1);
    case "+":
      return area.startsWith(segment.substring(1));
    case "-":
      return area.endsWith(segment.substring(1));
    default:
      return area.contains(segment);
  }
}

Iterable<Concept> checkToken(Entry entry, String token, bool forms, bool uses) {
  if (token[0] == "#") return checkTag(entry, token);
  final List<Concept> concepts = [];
  if (forms && entry.forms.any((f) => checkSegment(f.plain, token)))
    concepts.addAll(entry.uses.map(getConcept));
  if (uses)
    concepts.addAll(
      entry.uses.map(getConcept).where((c) => checkSegment(c.meaning, token)),
    );
  return concepts;
}

Iterable<Concept> checkQueries(
  Entry entry,
  Iterable<Iterable<String>> queries,
  bool forms,
  bool uses,
) {
  final concepts = Set<Concept>();
  for (final query in queries) {
    Iterable<Concept> _concepts = entry.uses.map(getConcept);
    for (final token in query) {
      final fits = checkToken(entry, token, forms, uses);
      _concepts = _concepts.where((m) => fits.contains(m));
    }
    _concepts.forEach((m) => concepts.add(m));
  }
  return concepts;
}

Iterable<Iterable<String>> parseQuery(String input) {
  return input
      .split(".")
      .map((q) => q.split(" ").map((t) => t.trim()).where((t) => t.isNotEmpty))
      .where((q) => q.isNotEmpty);
}
