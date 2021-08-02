import 'package:flutter/material.dart';

class SegmentCard extends StatelessWidget {
  final List<Widget> children;
  final double marginTop;

  const SegmentCard(
    {required this.children,
    this.marginTop = 16, 
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(top: marginTop),
      shape: RoundedRectangleBorder(),
      child: Column(children: children),
    );
  }
}
