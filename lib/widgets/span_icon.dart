import 'package:flutter/material.dart';

enum SpanIconColor { text, caption, primary }

class SpanIcon extends StatelessWidget {
  const SpanIcon(
    this.icon, {
    this.color = SpanIconColor.caption,
    this.padding = const EdgeInsets.only(right: 2),
    Key? key,
  }) : super(key: key);

  final IconData icon;
  final SpanIconColor color;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    Color? color;
    switch (this.color) {
      case SpanIconColor.text:
        color = null;
        break;
      case SpanIconColor.caption:
        color = Theme.of(context).textTheme.caption?.color;
        break;
      case SpanIconColor.primary:
        color = Theme.of(context).colorScheme.onPrimary;
        break;
    }
    return Padding(
      padding: padding,
      child: Icon(
        icon,
        size: 16,
        color: color,
      ),
    );
  }
}
