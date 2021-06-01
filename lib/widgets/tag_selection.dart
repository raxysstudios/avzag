import 'package:flutter/material.dart';

class TagSelection extends StatelessWidget {
  final List<String> tags;
  final ValueSetter<List<String>> setter;
  final List<String>? selected;
  final bool row;

  const TagSelection(
    this.tags,
    this.setter, {
    this.selected,
    this.row = false,
  });

  List<String> get sorted => tags
    ..sort(
      (a, b) {
        return a.compareTo(b);
      },
    );

  void toggleTag(String tag) {
    final update = [...selected ?? []];
    if (update.contains(tag))
      update.remove(tag);
    else
      update.add(tag);
    setter([...update]);
  }

  @override
  Widget build(BuildContext context) {
    final chips = sorted.map(
      (t) => InputChip(
        label: Text(t),
        selected: selected?.contains(t) ?? false,
        onPressed: () => toggleTag(t),
      ),
    );

    return row
        ? Container(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: chips
                  .map(
                    (c) => Padding(
                      padding: const EdgeInsets.all(2),
                      child: c,
                    ),
                  )
                  .toList(),
            ),
          )
        : Wrap(
            spacing: 4,
            children: chips.toList(),
          );
  }
}
