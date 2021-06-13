import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class ExpandableTitle extends StatelessWidget {
  final Iterable<Widget> children;
  const ExpandableTitle(this.children);

  @override
  Widget build(BuildContext context) {
    return ExpandablePanel(
      header: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        child: Row(
          children: [
            Transform.scale(
              scale: 1.5,
              child: CircleAvatar(
                backgroundImage: AssetImage('icon.png'),
                radius: 12,
              ),
            ),
            SizedBox(width: 32),
            Text(
              'Ævzag',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
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
      expanded: Column(
        children: [
          Divider(height: 0),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Icon(
                  Icons.landscape_outlined,
                  color: Colors.black54,
                ),
                SizedBox(height: 4),
                Text(
                  'Made with honor in\nDagestan, North Caucasus.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),
          Divider(height: 0),
          ...children,
        ],
      ),
    );
  }
}
