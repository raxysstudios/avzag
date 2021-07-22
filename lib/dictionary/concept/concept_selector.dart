import 'package:avzag/dictionary/concept/concept.dart';
import 'package:avzag/dictionary/concept/concept_creator.dart';
import 'package:avzag/dictionary/concept/concept_display.dart';
import 'package:avzag/utils.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ConceptSelect extends StatefulWidget {
  @override
  _ConceptSelectState createState() => _ConceptSelectState();
}

class _ConceptSelectState extends State<ConceptSelect> {
  bool creating = false;
  String query = '';
  Future<QuerySnapshot<Concept>>? search;

  Widget buildAddButton() {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Cannot find what you need?'),
          SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: () => setState(() {
              creating = true;
            }),
            icon: Icon(Icons.add_outlined),
            label: Text('New Concept'),
          ),
        ],
      ),
    );
  }

  String getLimit(String term) {
    final strFrontCode = term.substring(0, term.length - 1);
    final strEndCode = term.characters.last;
    final limit =
        strFrontCode + String.fromCharCode(strEndCode.codeUnitAt(0) + 1);
    return limit;
  }

  Widget buildSearch() {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            labelText: 'Search by meanings, tags',
          ),
          inputFormatters: [LowerCaseTextFormatter()],
          onChanged: (q) => setState(() {
            query = q;
            search = query.isEmpty
                ? null
                : FirebaseFirestore.instance
                    .collection('meta/dictionary/concepts')
                    .where('meaning', isGreaterThanOrEqualTo: q)
                    .where('meaning', isLessThan: getLimit(q))
                    .withConverter(
                      fromFirestore: (snapshot, _) =>
                          Concept.fromJson(snapshot.data()!),
                      toFirestore: (Concept object, _) => object.toJson(),
                    )
                    .get();
          }),
        ),
        if (search == null)
          buildAddButton()
        else
          FutureBuilder<QuerySnapshot<Concept>>(
            future: search,
            builder: (_, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                final docs = snapshot.data!.docs;
                return docs.isEmpty
                    ? buildAddButton()
                    : Expanded(
                        child: ListView(
                          children: [
                            for (final c in docs)
                              ConceptDisplay(
                                concept: c.data(),
                                onTap: () => Navigator.pop(context, c.id),
                              ),
                          ],
                        ),
                      );
              }
              return CircularProgressIndicator();
            },
          ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(creating ? 'Add concept' : 'Select concept'),
      contentPadding: EdgeInsets.zero,
      children: [
        Container(
          height: 512,
          child: creating ? ConceptCreator(query) : buildSearch(),
        ),
      ],
    );
  }
}
