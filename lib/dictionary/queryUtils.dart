import 'models.dart';

Iterable<String> checkTag(Entry entry, String tag) {
  tag = tag.substring(1);
  if (entry.tags?.contains(tag) ?? false)
    return entry.uses?.map((u) => u.meaning) ?? [];
  return entry.uses
          ?.where((u) => u.tags?.contains(tag) ?? false)
          .map((u) => u.meaning) ??
      [];
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

Iterable<String> checkToken(Entry entry, String token, bool forms, bool uses) {
  if (token[0] == "#") return checkTag(entry, token);
  final List<String> meanings = [];
  if (forms &&
      entry.uses != null &&
      entry.forms.any((f) => checkSegment(f.plain, token)))
    meanings.addAll(entry.uses!.map((u) => u.meaning));
  if (uses && entry.uses != null)
    meanings.addAll(
      entry.uses!.map((u) => u.meaning).where((m) => checkSegment(m, token)),
    );
  return meanings;
}

Iterable<String> checkQueries(
    Entry entry, List<List<String>> queries, bool forms, bool uses) {
  final meanings = Set<String>();
  for (final query in queries) {
    Iterable<String> _meanings = entry.uses?.map((u) => u.meaning) ?? [];
    for (final token in query) {
      final fits = checkToken(entry, token, forms, uses);
      _meanings = _meanings.where((m) => fits.contains(m));
    }
    _meanings.forEach((m) => meanings.add(m));
  }
  return meanings;
}

Iterable<Iterable<String>> parseQuery(String input) {
  return input
      .split(".")
      .map((q) => q.split(" ").map((t) => t.trim()).where((t) => t.isNotEmpty))
      .where((q) => q.isNotEmpty);
}
