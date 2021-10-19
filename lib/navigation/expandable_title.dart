import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableTitle extends StatelessWidget {
  final Widget child;
  const ExpandableTitle(
    this.child, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: const ListTile(
        leading: Icon(Icons.menu_outlined),
        contentPadding: EdgeInsets.only(left: 20),
        title: Text(
          'Ævzag',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      theme: const ExpandableThemeData(
        expandIcon: Icons.expand_more_outlined,
        collapseIcon: Icons.expand_more_outlined,
        iconPadding: EdgeInsets.only(
          right: 20,
          top: 16,
        ),
      ),
      collapsed: const Offstage(),
      expanded: child,
    );
  }
}
