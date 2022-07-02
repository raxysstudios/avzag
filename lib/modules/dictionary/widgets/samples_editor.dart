import 'package:avzag/shared/widgets/compact_input.dart';
import 'package:flutter/material.dart';

import '../models/sample.dart';

class SamplesEditor extends StatefulWidget {
  const SamplesEditor(
    this.title,
    this.samples, {
    this.lowercase = true,
    Key? key,
  }) : super(key: key);

  final String title;
  final bool lowercase;
  final List<Sample> samples;

  @override
  State<SamplesEditor> createState() => _SamplesEditorState();
}

class _SamplesEditorState extends State<SamplesEditor> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (final s in widget.samples)
          Column(
            children: [
              const Divider(),
              CompactInput(
                Icons.short_text_outlined,
                'Text',
                s.text,
                (t) => s.text = t,
                lowercase: widget.lowercase,
                noEmpty: true,
                trailing: IconButton(
                  tooltip: 'Remove',
                  onPressed: () => setState(() {
                    widget.samples.remove(s);
                  }),
                  icon: const Icon(Icons.remove_circle_outline_outlined),
                ),
              ),
              CompactInput(
                Icons.info_outlined,
                'Meaning',
                s.meaning,
                (t) => s.meaning = t,
                lowercase: widget.lowercase,
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextButton.icon(
            onPressed: () => setState(() {
              widget.samples.add(Sample(''));
            }),
            icon: const Icon(Icons.add_circle_outline_outlined),
            label: Text(widget.title),
          ),
        ),
      ],
    );
  }
}
