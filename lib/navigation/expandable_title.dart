import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableTitle extends StatelessWidget {
  final Widget child;
  const ExpandableTitle(this.child);

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Text(
          'Ævzag',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      theme: ExpandableThemeData(
        expandIcon: Icons.expand_more_outlined,
        collapseIcon: Icons.expand_more_outlined,
        iconPadding: const EdgeInsets.only(
          right: 16,
          top: 16,
        ),
      ),
      collapsed: Offstage(),
      expanded: child,
    );
  }
}
