import 'package:flutter/material.dart';

class ExpandableTile extends StatefulWidget {
  const ExpandableTile({
    required this.header,
    required this.body,
    Key? key,
  }) : super(key: key);

  final Widget header;
  final Widget body;

  @override
  State<ExpandableTile> createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  var isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (index, value) => setState(() {
        isExpanded = !isExpanded;
      }),
      expandedHeaderPadding: EdgeInsets.zero,
      children: [
        ExpansionPanel(
          backgroundColor: Colors.transparent,
          isExpanded: isExpanded,
          canTapOnHeader: true,
          headerBuilder: (_, __) => widget.header,
          body: widget.body,
        ),
      ],
    );
  }
}
