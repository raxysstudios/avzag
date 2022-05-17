import 'package:avzag/shared/widgets/column_card.dart';
import 'package:avzag/shared/widgets/markdown_text.dart';
import 'package:flutter/material.dart';

class Segment extends StatelessWidget {
  const Segment({
    required this.title,
    this.subtitle,
    this.body,
    this.children,
    Key? key,
  }) : super(key: key);

  final String title;
  final String? subtitle;
  final String? body;
  final Iterable<Widget>? children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    const padding = EdgeInsets.symmetric(horizontal: 16);
    return ColumnCard(
      divider: const SizedBox(height: 8),
      padding: const EdgeInsets.symmetric(vertical: 16),
      children: [
        Padding(
          padding: padding,
          child: Text(
            title,
            style: theme.headline6,
          ),
        ),
        if (subtitle != null)
          Padding(
            padding: padding,
            child: Text(
              subtitle!,
              style: theme.caption,
            ),
          ),
        if (body != null)
          Padding(
            padding: padding,
            child: MarkdownText(body!),
          ),
        if (children != null) ...children!,
      ],
    );
  }
}
