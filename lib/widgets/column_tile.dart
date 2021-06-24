import 'package:flutter/material.dart';

class ColumnTile extends StatelessWidget {
  final Widget title;
  final String? subtitle;
  final Function()? onTap;
  final Widget? leading;
  final Widget? trailing;
  final double gap;
  final EdgeInsets padding;
  final double minVerticalPadding;
  final bool leadingSpace;

  const ColumnTile(
    this.title, {
    this.subtitle,
    this.onTap,
    this.leading,
    this.trailing,
    this.minVerticalPadding = 16,
    this.leadingSpace = true,
    this.gap = 0,
    this.padding = const EdgeInsets.symmetric(horizontal: 16),
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      horizontalTitleGap: gap,
      minVerticalPadding: minVerticalPadding,
      contentPadding: padding,
      leading: leading ?? (leadingSpace ? SizedBox(width: 24) : null),
      trailing: trailing,
      onTap: onTap,
      title: title,
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle!,
              style: TextStyle(fontSize: 14),
            ),
    );
  }
}
