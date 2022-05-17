import 'package:avzag/utils/open_link.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MarkdownText extends StatelessWidget {
  const MarkdownText(
    this.text, {
    this.selectable = true,
    Key? key,
  }) : super(key: key);

  final bool selectable;
  final String text;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: text,
      selectable: selectable,
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(
          fontSize: 16,
        ),
        strong: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      onTapLink: (_, link, __) {
        if (link != null) openLink(link);
      },
    );
  }
}
