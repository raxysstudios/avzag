import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

class MarkdownText extends StatelessWidget {
  const MarkdownText(
    this.text, {
    Key? key,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: text,
      styleSheet: MarkdownStyleSheet(
        p: const TextStyle(
          fontSize: 16,
        ),
        strong: const TextStyle(
          fontWeight: FontWeight.w500,
        ),
      ),
      onTapLink: (_, link, __) {
        if (link != null) {
          launchUrl(
            Uri.parse(link),
            mode: LaunchMode.externalApplication,
          );
        }
      },
    );
  }
}
