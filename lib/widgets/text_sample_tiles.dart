import 'package:flutter/material.dart';
import 'editor_dialog.dart';

class TextSample {
  String plain;
  String? ipa;
  String? glossed;
  String? translation;

  TextSample({required this.plain, this.ipa, this.glossed, this.translation});

  TextSample.fromJson(Map<String, dynamic> json)
      : this(
          plain: json['plain'],
          ipa: json['ipa'],
          glossed: json['glossed'],
          translation: json['translation'],
        );

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['plain'] = plain;
    if (ipa?.isNotEmpty ?? false) data['ipa'] = ipa;
    if (glossed?.isNotEmpty ?? false) data['glossed'] = glossed;
    if (translation?.isNotEmpty ?? false) data['translation'] = translation;
    return data;
  }
}

class TextSampleTiles extends StatelessWidget {
  final List<TextSample>? samples;
  final ValueSetter<List<TextSample>?>? onEdited;

  final IconData? icon;
  final bool scholar;
  final bool row;

  const TextSampleTiles({
    this.samples,
    this.onEdited,
    this.icon,
    this.scholar = true,
    this.row = false,
  });

  SelectableText buildText(TextSample sample) {
    return SelectableText.rich(
      TextSpan(
        style: TextStyle(
          color: Colors.black54,
          fontSize: 14,
        ),
        children: [
          TextSpan(
            text: sample.plain,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 16,
            ),
          ),
          if (sample.translation != null)
            TextSpan(
              text: '\n' + sample.translation!,
              style: TextStyle(
                color: Colors.black54,
                fontSize: 16,
              ),
            ),
          if (scholar)
            TextSpan(
              text: [
                '',
                sample.ipa,
                sample.glossed,
              ].where((t) => t != null).join(row ? ' • ' : '\n'),
            )
        ],
      ),
    );
  }

  void showEditor(BuildContext context, int index) {
    final samples = this.samples ?? [];
    if (index == samples.length) samples.add(TextSample(plain: 'sample'));

    final result = EditorDialogResult(samples);
    final sample = samples[index];
    final inputs = [
      [sample.plain, (text) => sample.plain = text],
      [sample.ipa, (text) => sample.ipa = text],
      [sample.glossed, (text) => sample.glossed = text],
    ];

    showEditorDialog(
      context,
      result: result,
      setter: onEdited!,
      title: 'Edit sample',
      content: SingleChildScrollView(
        child: Column(
          children: [
            for (final input in inputs)
              TextFormField(
                initialValue: input[0] as String?,
                onChanged: (text) => (input[1] as ValueSetter<String>)(
                  text.trim(),
                ),
              ),
          ],
        ),
      ),
    );
  }

  ListTile buildTile(BuildContext context, int index) {
    return ListTile(
      leading: Icon(
        icon,
        color: index == 0 ? null : Colors.transparent,
      ),
      title: samples?.isEmpty ?? true
          ? Text(
              'Tap to add samples',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            )
          : buildText(samples![index]),
      onTap: onEdited == null ? null : () => showEditor(context, index),
      trailing: onEdited == null
          ? null
          : index == 0
              ? IconButton(
                  onPressed: () => showEditor(
                    context,
                    samples?.length ?? 0,
                  ),
                  icon: Icon(Icons.add_outlined),
                  tooltip: 'Add sample',
                )
              : IconButton(
                  onPressed: () {
                    samples!.removeAt(index);
                    onEdited!(samples);
                  },
                  icon: Icon(Icons.remove_outlined),
                  tooltip: 'Remove sample',
                ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (samples == null && onEdited == null) return Offstage();
    return Column(
      children: [
        buildTile(context, 0),
        if (samples != null)
          for (var i = 1; i < samples!.length; i++) buildTile(context, i),
      ],
    );
  }
}
