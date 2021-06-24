import 'package:avzag/widgets/column_tile.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'concept.dart';

class ConceptDisplay extends StatelessWidget {
  final Concept concept;
  final bool scholar;
  final Function()? onTap;

  const ConceptDisplay(
    this.concept, {
    this.scholar = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ColumnTile(
      Text(
        capitalize(concept.meaning),
        style: TextStyle(fontSize: 16),
      ),
      subtitle: prettyTags(scholar ? concept.tags : null),
      leading: Icon(Icons.lightbulb_outline),
      onTap: onTap,
    );
  }
}
