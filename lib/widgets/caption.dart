import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'span_icon.dart';

class Caption extends StatelessWidget {
  const Caption(
    this.text, {
    this.icon,
    this.padding = const EdgeInsets.all(16),
    Key? key,
  }) : super(key: key);

  final String text;
  final IconData? icon;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null) SpanIcon(icon!),
          Text(
            text,
            style: Theme.of(context).textTheme.caption?.copyWith(
                  fontSize: 14,
                ),
          ),
        ],
      ),
    );
  }
}
