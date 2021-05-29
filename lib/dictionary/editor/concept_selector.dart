import 'package:avzag/dictionary/concept_display.dart';
import 'package:flutter/material.dart';
import '../models.dart';
import '../store.dart';

class ConceptSelect extends StatefulWidget {
  final ValueSetter<String> setter;
  ConceptSelect(this.setter);

  @override
  _ConceptSelectState createState() => _ConceptSelectState();
}

class _ConceptSelectState extends State<ConceptSelect> {
  String query = "";
  List<MapEntry<String, Concept>> get filtered => concepts.entries.where(
        (e) {
          final c = e.value;
          return [
            c.meaning,
            ...(c.tags ?? []),
          ].any((t) => t.contains(query));
        },
      ).toList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 8),
            labelText: "Search by meanings, tags",
          ),
          onChanged: (q) => setState(() => query = q),
        ),
        Divider(height: 0),
        Expanded(
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
      ],
    );
  }
}
