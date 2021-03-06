import 'package:bazur/models/sample.dart';
import 'package:bazur/models/word.dart';
import 'package:bazur/shared/extensions.dart';
import 'package:markdown/markdown.dart';

String _getLink(Word word) => 'https://bazur.raxys.app/${word.id}';

String previewArticle(Word word) => '''
š Bazur ā¢ ${word.language.titled}
š ${word.headword.titled} ā ${word.definitions.map((d) => d.translation.titled).join(', ')}
${_getLink(word)}''';

String _cleanMarkdown(String md) => markdownToHtml(md, inlineOnly: true)
    .replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '')
    .trim();

String textifyArticle(Word word) {
  String tags(Iterable<String> ts) => '#ļøā£ ${ts.join(", ")}';
  Iterable<String> samples(Iterable<Sample> ss) => ss.map(
        (s) => [
          'š¹ ${s.text}',
          if (s.meaning != null) ' ā¢ ${s.meaning!}',
        ].join(),
      );
  String note(String n) => 'š ${_cleanMarkdown(n)}';

  final article = [
    'š Bazur ā¢ ${word.language.titled}',
    _getLink(word),
    '\nš ${word.headword.titled}',
    if (word.ipa != null) 'š ${word.ipa}',
    if (word.tags.isNotEmpty) tags(word.tags),
    if (word.note?.isNotEmpty ?? false) note(word.note!),
    if (word.forms.isNotEmpty) ...samples(word.forms),
    for (final d in word.definitions) ...[
      '\nš”${word.definitions.indexOf(d) + 1}. ${d.translation.titled}',
      if (d.tags.isNotEmpty) tags(d.tags),
      if (d.note?.isNotEmpty ?? false) note(d.note!),
      if (d.examples.isNotEmpty) ...samples(d.examples),
    ],
  ];
  return article.join('\n');
}
