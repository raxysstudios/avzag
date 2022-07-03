import 'package:avzag/modules/dictionary/models/sample.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:markdown/markdown.dart';

import '../models/word.dart';

String _getWordLink(Word word) =>
    'https://avzag.raxys.app/dictionary/${word.id}';

String previewArticle(Word word) => '''
🌄 Avzag • ${word.language.titled}
🔖 ${word.headword.titled} — ${word.uses.map((u) => u.term.titled).join(', ')}
${_getWordLink(word)}''';

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
    '🌄 Avzag • ${word.language.titled}',
    _getWordLink(word),
    '\n🔖 ${word.headword.titled}',
    if (word.ipa != null) '🔉 ${word.ipa}',
    if (word.tags.isNotEmpty) tags(word.tags),
    if (word.note?.isNotEmpty ?? false) note(word.note!),
    if (word.forms.isNotEmpty) ...samples(word.forms),
    if (word.uses.isNotEmpty)
      for (final use in word.uses) ...[
        '\n💡 ${use.term.titled}',
        if (use.tags.isNotEmpty) tags(use.tags),
        if (use.note?.isNotEmpty ?? false) note(use.note!),
        if (use.examples.isNotEmpty) ...samples(use.examples),
      ],
  ];
  return article.join('\n');
}
