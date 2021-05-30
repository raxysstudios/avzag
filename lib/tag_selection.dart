import 'package:flutter/material.dart';

class TagSelection extends StatelessWidget {
  final List<String> tags;
  final ValueSetter<List<String>> setter;
  final List<String>? selected;

  const TagSelection(
    this.tags,
    this.setter, {
    this.selected,
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
    return Container(
      height: 44,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          for (final t in sorted)
            Padding(
              padding: const EdgeInsets.all(2),
              child: InputChip(
                label: Text(t),
                selected: selected?.contains(t) ?? false,
                onPressed: () => toggleTag(t),
              ),
            ),
        ],
      ),
    );
  }
}
