import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/markdown_text.dart';
import 'package:flutter/material.dart';

class Segment extends StatelessWidget {
  const Segment({
    required this.title,
    this.subtitle,
    this.body,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String? body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return ColumnCard(
      divider: const SizedBox(height: 8),
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          title,
          style: theme.headline6,
        ),
        if (subtitle != null)
          Text(
            subtitle!,
            style: theme.caption,
          ),
        if (body != null) MarkdownText(body!),
      ],
    );
  }
}
