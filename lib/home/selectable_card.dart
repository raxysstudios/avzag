import 'package:flutter/material.dart';

class SelectableCard extends StatelessWidget {
  SelectableCard({
    required this.children,
    this.selected = false,
    this.onTap,
  });

  final List<Widget> children;
  final bool selected;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: selected ? 2 : 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      margin: const EdgeInsets.all(0),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            ...children,
            AnimatedPositioned(
              left: selected ? 0 : -28,
              bottom: selected ? 0 : -28,
              duration: Duration(milliseconds: 200),
              curve: standardEasing,
              child: Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(8),
                  ),
                ),
                child: Icon(
                  Icons.check,
                  color: Theme.of(context).cardColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
