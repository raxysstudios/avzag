import 'package:flutter/material.dart';

class TagSelector extends StatefulWidget {
  final List<String> tags;
  final ValueSetter<List<String>> setter;
  final List<String>? initial;

  const TagSelector(
    this.tags,
    this.setter, {
    this.initial,
  });

  @override
  _TagSelectorState createState() => _TagSelectorState();
}

class _TagSelectorState extends State<TagSelector> {
  late List<String> selected;
  List<String> get sorted => widget.tags
    ..sort((a, b) {
      return a.compareTo(b);
    });

  @override
  void initState() {
    super.initState();
    selected = widget.initial?.toList() ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Wrap(
          children: [
            for (final t in sorted)
              InputChip(
                label: Text(t),
                selected: selected.contains(t),
                onPressed: () => setState(() {
                  if (selected.contains(t))
                    selected.remove(t);
                  else
                    selected.add(t);
                }),
              )
          ],
        ),
        OutlinedButton.icon(
          onPressed: () => widget.setter(selected),
          icon: Icon(Icons.save_outlined),
          label: Text("Save"),
        ),
      ],
    );
  }
}
