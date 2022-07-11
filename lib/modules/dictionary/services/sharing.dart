import 'package:bazur/models/sample.dart';
import 'package:bazur/models/word.dart';
import 'package:bazur/shared/extensions.dart';
import 'package:markdown/markdown.dart';

String _getLink(Word word) => 'https://bazur.raxys.app/${word.id}';

String previewArticle(Word word) => '''
🌄 Bazur • ${word.language.titled}
🔖 ${word.headword.titled} — ${word.definitions.map((d) => d.translation.titled).join(', ')}
${_getLink(word)}''';

String _cleanMarkdown(String md) => markdownToHtml(md, inlineOnly: true)
    .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '')
    .trim();

String textifyArticle(Word word) {
  String tags(Iterable<String> ts) => '#️⃣ ${ts.join(", ")}';
  Iterable<String> samples(Iterable<Sample> ss) => ss.map(
        (s) => [
          '🔹 ${s.text}',
          if (s.meaning != null) ' • ${s.meaning!}',
        ].join(),
      );
  String note(String n) => '📝 ${_cleanMarkdown(n)}';

  final article = [
    '🌄 Bazur • ${word.language.titled}',
    _getLink(word),
    '\n🔖 ${word.headword.titled}',
    if (word.ipa != null) '🔉 ${word.ipa}',
    if (word.tags.isNotEmpty) tags(word.tags),
    if (word.note?.isNotEmpty ?? false) note(word.note!),
    if (word.forms.isNotEmpty) ...samples(word.forms),
    for (final d in word.definitions) ...[
      '\n💡${word.definitions.indexOf(d) + 1}. ${d.translation.titled}',
      if (d.tags.isNotEmpty) tags(d.tags),
      if (d.note?.isNotEmpty ?? false) note(d.note!),
      if (d.examples.isNotEmpty) ...samples(d.examples),
    ],
  ];
  return article.join('\n');
}
