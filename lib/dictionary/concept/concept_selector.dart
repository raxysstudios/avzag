import 'package:avzag/dictionary/concept/concept_display.dart';
import 'package:avzag/tag_selection.dart';
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
        onChanged: (m) => query = m,
      ),
      SizedBox(height: 16),
      Text("Choose semantic tags"),
      Expanded(
        child: TagSelection(
          semanticTags,
          (t) => setState(
            () => tags = t,
          ),
          selected: tags,
        ),
      ),
      OutlinedButton.icon(
        onPressed: () {},
        icon: Icon(Icons.check_outlined),
        label: Text("Save & Select"),
      ),
    ];
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
