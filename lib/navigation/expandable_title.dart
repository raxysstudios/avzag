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
          horizontal: 20,
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
            SizedBox(width: 34),
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
          right: 20,
          top: 16,
        ),
      ),
      collapsed: Offstage(),
      expanded: Column(
        children: [
          Card(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Icon(
                        Icons.landscape_outlined,
                        color: Colors.black54,
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Made with honor in Dagestan, North Caucasus.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ],
                  ),
                ),
                Divider(height: 0),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlutterLogo(size: 24),
                      Image.asset(
                        'firebase.png',
                        width: 24,
                        height: 24,
                      ),
                      Image.asset(
                        'algolia.png',
                        width: 24,
                        height: 24,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ...children
        ],
      ),
    );
  }
}
