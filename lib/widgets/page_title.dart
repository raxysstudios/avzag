import 'package:avzag/utils/utils.dart';
import 'package:flutter/material.dart';

class PageTitle extends StatelessWidget {
  final String title;
  final String? subtitle;

  const PageTitle(
    this.title, {
    this.subtitle,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return RichText(
      text: TextSpan(
        children: [
          TextSpan(
            text: capitalize(title),
            style: theme.headline6,
          ),
          if (subtitle != null)
            TextSpan(
              text: '\n' + capitalize(subtitle!),
              style: theme.subtitle2?.copyWith(
                color: theme.caption?.color,
              ),
            )
        ],
      ),
    );
  }
}
