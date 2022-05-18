import 'package:avzag/shared/widgets/compact_input.dart';
import 'package:avzag/shared/widgets/modals/danger_dialog.dart';
import 'package:flutter/material.dart';

import '../models/sample.dart';

class SamplesEditor extends StatefulWidget {
  const SamplesEditor(
    this.icon,
    this.title,
    this.samples, {
    this.lowercase = true,
    Key? key,
  }) : super(key: key);

  final IconData icon;
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
      children: [
        ListTile(
          horizontalTitleGap: 0,
          contentPadding: const EdgeInsets.symmetric(horizontal: 20),
          leading: Icon(widget.icon),
          title: Center(child: Text(widget.title)),
          trailing: const Icon(Icons.add_rounded),
          onTap: () => setState(() {
            widget.samples.add(Sample(''));
          }),
        ),
        for (final s in widget.samples)
          Column(
            children: [
              const Divider(),
              CompactInput(
                Icons.short_text_rounded,
                'Text',
                s.text,
                (t) => s.text = t,
                lowercase: widget.lowercase,
                noEmpty: true,
                trailing: IconButton(
                  onPressed: () => showDangerDialog(
                    context,
                    () => setState(() {
                      widget.samples.remove(s);
                    }),
                    'Delete sample',
                  ),
                  icon: const Icon(Icons.delete_rounded),
                ),
              ),
              CompactInput(
                Icons.lightbulb_rounded,
                'Meaning',
                s.meaning,
                (t) => s.meaning = t,
                lowercase: widget.lowercase,
              ),
            ],
          ),
        const Divider(),
      ],
    );
  }
}
