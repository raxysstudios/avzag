import 'package:flutter/material.dart';
import 'editor_dialog.dart';

class TextSample {
  String plain;
  String? ipa;
  String? glossed;
  String? translation;

  TextSample(
    this.plain, {
    this.ipa,
    this.glossed,
    this.translation,
  });

  TextSample.fromJson(Map<String, dynamic> json)
      : this(
          json['plain'],
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

class TextSampleTiles extends StatefulWidget {
  final List<TextSample>? samples;
  final ValueSetter<List<TextSample>?>? onEdited;
  final IconData? icon;
  final bool translation;
  final bool noEmpty;

  const TextSampleTiles({
    this.samples,
    this.onEdited,
    this.icon,
    this.translation = false,
    this.noEmpty = false,
  });

  @override
  _TextSampleTilesState createState() => _TextSampleTilesState();
}

class _TextSampleTilesState extends State<TextSampleTiles> {
  bool advanced = false;

  TextSpan getTextSpan(int index) {
    final extended = this.advanced || widget.onEdited != null;
    final sample = widget.samples![index];
    final fields = [
      sample.translation,
      if (extended) ...[
        sample.ipa == null ? null : '/${sample.ipa}/',
        sample.glossed,
      ]
    ].where((t) => t != null);

    return TextSpan(
      style: TextStyle(
        color: Colors.black54,
        fontSize: 16,
      ),
      children: [
        TextSpan(
          text: sample.plain,
          style: TextStyle(color: Colors.black87),
        ),
        if (fields.length > 0)
          TextSpan(
            text: ['', ...fields].join(' • '),
          )
      ],
    );
  }

  void showEditor(BuildContext context, int index) {
    final samples = widget.samples ?? [];
    if (index == samples.length) samples.add(TextSample('sample'));

    final result = samples;
    final sample = samples[index];
    final inputs = [
      [sample.plain, (text) => sample.plain = text, 'Plain text'],
      [sample.ipa, (text) => sample.ipa = text, 'IPA (glossed)'],
      [sample.glossed, (text) => sample.glossed = text, 'Leipzig-glossed'],
      if (widget.translation)
        [
          sample.translation,
          (text) => sample.translation = text,
          'Translation'
        ],
    ];

    showEditorDialog(
      context,
      result: () => result,
      callback: widget.onEdited!,
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
                decoration: InputDecoration(
                  labelText: input[2] as String,
                ),
              ),
          ],
        ),
      ),
    );
  }

  ListTile buildTile(BuildContext context, int index) {
    return ListTile(
      minVerticalPadding: 8,
      leading: Icon(
        widget.icon,
        color: index == 0 ? null : Colors.transparent,
      ),
      title: widget.samples?.isEmpty ?? true
          ? Text(
              'Tap to add samples',
              style: TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.black54,
              ),
            )
          : widget.onEdited == null
              ? SelectableText.rich(getTextSpan(index))
              : RichText(text: getTextSpan(index)),
      onTap: widget.onEdited == null ? null : () => showEditor(context, index),
      trailing: widget.onEdited == null
          ? null
          : index == 0
              ? IconButton(
                  onPressed: () => showEditor(
                    context,
                    widget.samples?.length ?? 0,
                  ),
                  icon: Icon(Icons.add_outlined),
                  tooltip: 'Add sample',
                )
              : widget.samples!.length == 1 && widget.noEmpty
                  ? null
                  : IconButton(
                      onPressed: () {
                        widget.samples!.removeAt(index);
                        widget.onEdited!(widget.samples);
                      },
                      icon: Icon(Icons.remove_outlined),
                      tooltip: 'Remove sample',
                    ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.samples == null && widget.onEdited == null) return Offstage();
    if (widget.onEdited == null)
      return ListTile(
        minVerticalPadding: 12,
        onTap: () => setState(() {
          advanced = !advanced;
        }),
        leading: Icon(widget.icon),
        title: SelectableText.rich(
          TextSpan(
            children: [
              getTextSpan(0),
              for (var i = 1; i < widget.samples!.length; i++) ...[
                TextSpan(text: '\n'),
                getTextSpan(i),
              ],
            ],
          ),
        ),
      );
    return Column(
      children: [
        buildTile(context, 0),
        if (widget.samples != null)
          for (var i = 1; i < widget.samples!.length; i++)
            buildTile(context, i),
      ],
    );
  }
}