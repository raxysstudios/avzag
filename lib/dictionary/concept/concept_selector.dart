import 'package:avzag/dictionary/concept/concept_creator.dart';
import 'package:avzag/dictionary/concept/concept_display.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import '../store.dart';

class ConceptSelect extends StatefulWidget {
  @override
  _ConceptSelectState createState() => _ConceptSelectState();
}

class _ConceptSelectState extends State<ConceptSelect> {
  bool creating = false;
  String query = '';

  Widget buildSearch() {
    final filtered = DictionaryStore.concepts.entries.where(
      (e) {
        final c = e.value;
        return [
          c.meaning,
          ...(c.tags ?? []),
        ].any((t) => t.contains(query));
      },
    );
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
          }),
        ),
        Expanded(
          child: filtered.isEmpty
              ? Column(
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
                )
              : ListView(
                  children: [
                    for (final c in filtered)
                      ConceptDisplay(
                        c.value,
                        onTap: () => Navigator.pop(context, c.key),
                      ),
                  ],
                ),
        )
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
