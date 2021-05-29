import 'package:avzag/dictionary/models.dart';
import 'package:flutter/material.dart';

import '../utils.dart';

class ConceptDisplay extends StatelessWidget {
  final Concept concept;
  final bool scholar;

  const ConceptDisplay(
    this.concept, {
    this.scholar = true,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: capitalize(concept.meaning),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        children: scholar && concept.tags != null
            ? [
                TextSpan(
                  text: ["", ...concept.tags!].join(" "),
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]
            : null,
      ),
    );
  }
}
