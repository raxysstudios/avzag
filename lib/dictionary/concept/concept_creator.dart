import 'package:avzag/dictionary/store.dart';
import 'package:avzag/widgets/tag_selection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'concept.dart';

class ConceptCreator extends StatefulWidget {
  final String meaning;
  const ConceptCreator(this.meaning);

  @override
  _ConceptCreatorState createState() => _ConceptCreatorState();
}

class _ConceptCreatorState extends State<ConceptCreator> {
  final formKey = GlobalKey<FormState>();
  bool uploading = false;
  String meaning = "";
  List<String> tags = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Form(
          key: formKey,
          child: TextFormField(
            initialValue: widget.meaning,
            decoration: InputDecoration(
              labelText: 'Concept meaning',
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            validator: (v) => v?.isEmpty ?? false ? 'Cannot be empty' : null,
            onChanged: (m) {
              meaning = m;
            },
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Semantic tags',
            textAlign: TextAlign.start,
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              TagSelection(
                DictionaryStore.semanticTags,
                (t) => setState(() {
                  tags = t;
                }),
                selected: tags,
              )
            ],
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            uploading
                ? CircularProgressIndicator()
                : OutlinedButton.icon(
                    onPressed: uploadConcept,
                    icon: Icon(Icons.check_outlined),
                    label: Text('Save & Select'),
                  ),
          ],
        ),
      ],
    );
  }

  void uploadConcept() {
    if (!formKey.currentState!.validate()) return;
    setState(() {
      uploading = true;
    });
    final concept = Concept(meaning: meaning, tags: tags);
    FirebaseFirestore.instance
        .collection('meta/dictionary/concepts')
        .add(concept.toJson())
        .then((d) {
      DictionaryStore.concepts[d.id] = concept;
      return d.id;
    }).then(
      (id) => Navigator.pop(context, id),
    );
  }
}
