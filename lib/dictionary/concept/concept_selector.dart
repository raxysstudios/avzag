import 'package:avzag/dictionary/concept/concept.dart';
import 'package:avzag/dictionary/concept/concept_display.dart';
import 'package:avzag/widgets/tag_selection.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../store.dart';

class ConceptSelect extends StatefulWidget {
  final ValueSetter<String> setter;
  ConceptSelect(this.setter);

  @override
  _ConceptSelectState createState() => _ConceptSelectState();
}

class _ConceptSelectState extends State<ConceptSelect> {
  bool creating = false;
  bool uploading = false;
  List<String> tags = [];
  String query = "";

  List<Widget> buildSearch() {
    final filtered = concepts.entries.where(
      (e) {
        final c = e.value;
        return [
          c.meaning,
          ...(c.tags ?? []),
        ].any((t) => t.contains(query));
      },
    ).toList();

    return [
      TextField(
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          labelText: "Search by meanings, tags",
        ),
        onChanged: (q) => setState(() => query = q),
      ),
      Divider(height: 0),
      Expanded(
        child: filtered.isEmpty
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Cannot find what you need?"),
                  OutlinedButton.icon(
                    onPressed: () => setState(
                      () => creating = true,
                    ),
                    icon: Icon(Icons.add_outlined),
                    label: Text("New Concept"),
                  ),
                ],
              )
            : Container(
                child: ListView.builder(
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final c = filtered[i];
                    return InkWell(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 16,
                        ),
                        child: ConceptDisplay(c.value),
                      ),
                      onTap: () => widget.setter(c.key),
                    );
                  },
                ),
              ),
      )
    ];
  }

  List<Widget> buildForm() {
    return [
      TextFormField(
        initialValue: query,
        decoration: InputDecoration(
          labelText: "Concept meaning",
        ),
        validator: (v) => v?.isEmpty ?? false ? 'Cannot be empty' : null,
        onChanged: (m) => query = m,
      ),
      SizedBox(height: 16),
      Text("Semantic tags"),
      Expanded(
        child: TagSelection(
          semanticTags,
          (t) => setState(
            () => tags = t,
          ),
          selected: tags,
        ),
      ),
      uploading
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            )
          : OutlinedButton.icon(
              onPressed: uploadConcept,
              icon: Icon(Icons.check_outlined),
              label: Text("Save & Select"),
            ),
    ];
  }

  Future<void> uploadConcept() async {
    setState(() => uploading = true);
    final concept = Concept(meaning: query, tags: tags);
    final id = await FirebaseFirestore.instance
        .collection('meta/dictionary/concepts')
        .add(concept.toJson())
        .then((d) {
      concepts[d.id] = concept;
      return d.id;
    });
    widget.setter(id);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...creating ? buildForm() : buildSearch(),
      ],
    );
  }
}
