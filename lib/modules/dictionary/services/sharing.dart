import 'package:avzag/modules/dictionary/models/sample.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/utils.dart';
import 'package:markdown/markdown.dart';

import '../models/word.dart';

String _getWordLink(Word word) =>
    'https://avzag.raxys.app/dictionary/${word.id}';

String previewArticle(Word word) => '''
Avzag • ${word.language.titled}
${word.headword.titled} — ${word.uses.map((u) => u.term.titled).join(', ')}
${_getWordLink(word)}
''';

String textifyArticle(Word word, [bool html = false]) {
  String b(String s) => '**$s**';
  String i(String s) => '*$s*';
  String c(String s) => '`$s`';
  String u(String s) => '<u>$s</u>';

  String tags(Iterable<String> ts) => i('# ${ts.join(", ")}');

  String samples(Iterable<Sample> ss) => ss
      .map((s) => '- ${i([
            b(s.text),
            if (s.meaning != null) ...[
              ':',
              s.meaning!,
            ],
          ].join(' '))}')
      .join('\n');

  final link = _getWordLink(word);
  final title = b('avzag • ${word.language}'.titled);
  final article = [
    if (html)
      '[$title]($link)'
    else ...[
      title,
      link,
    ],
    '',
    b(word.headword.titled),
    if (word.ipa != null) c('[${word.ipa}]'),
    if (word.tags.isNotEmpty) tags(word.tags),
    if (word.note?.isNotEmpty ?? false) word.note!,
    if (word.forms.isNotEmpty) samples(word.forms),
    if (word.uses.isNotEmpty)
      for (final use in word.uses) ...[
        '',
        u(b(use.term.titled)),
        if (use.tags.isNotEmpty) tags(use.tags),
        if (use.note?.isNotEmpty ?? false) use.note!,
        if (use.examples.isNotEmpty) samples(use.examples),
      ],
  ];
  final code = markdownToHtml(
    article.join('\n'),
    inlineOnly: true,
  );
  return html ? code : stripHtml(code);
}
