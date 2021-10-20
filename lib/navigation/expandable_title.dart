import 'package:avzag/widgets/raxys_logo.dart';
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
      header: ListTile(
        leading: Transform.scale(
          scale: 7,
          child: const Opacity(
            opacity: .2,
            child: RaxysLogo(size: 24),
          ),
        ),
        contentPadding: const EdgeInsets.only(left: 20),
        title: const Text(
          'Ævzag',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      theme: ExpandableThemeData(
        expandIcon: Icons.expand_more_outlined,
        collapseIcon: Icons.expand_more_outlined,
        iconPadding: const EdgeInsets.only(
          right: 20,
          top: 16,
        ),
        iconColor: Theme.of(context).iconTheme.color,
      ),
      collapsed: const Offstage(),
      expanded: child,
    );
  }
}
