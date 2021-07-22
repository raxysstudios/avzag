import 'package:avzag/widgets/column_tile.dart';
import 'package:avzag/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'concept.dart';

class ConceptDisplay extends StatelessWidget {
  final String? id;
  final Concept? concept;
  final bool scholar;
  final Function()? onTap;

  late final Future<DocumentSnapshot<Concept>>? loader = id == null
      ? null
      : FirebaseFirestore.instance
          .doc('meta/dictionary/concepts/$id')
          .withConverter(
            fromFirestore: (snapshot, _) => Concept.fromJson(snapshot.data()!),
            toFirestore: (Concept object, _) => object.toJson(),
          )
          .get();

  ConceptDisplay({
    this.id,
    this.concept,
    this.scholar = true,
    this.onTap,
  });

  Widget showConcept(Concept? concept) {
    return ColumnTile(
      Text(
        concept == null ? '...' : capitalize(concept.meaning),
        style: TextStyle(fontSize: 16),
      ),
      subtitle:
          concept == null ? '...' : prettyTags(scholar ? concept.tags : null),
      leading: Icon(Icons.lightbulb_outline),
      onTap: onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    if (concept != null) return showConcept(concept!);
    return FutureBuilder<DocumentSnapshot<Concept>>(
      future: loader,
      builder: (context, snapshot) {
        return showConcept(snapshot.data?.data());
      },
    );
  }
}
