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

class TextSampleTiles extends StatefulWidget {
  final List<TextSample>? samples;
  final ValueSetter<List<TextSample>?>? onEdited;
  final IconData? icon;
  final bool row;

  const TextSampleTiles({
    this.samples,
    this.onEdited,
    this.icon,
    this.row = false,
  });

  @override
  _TextSampleTilesState createState() => _TextSampleTilesState();
}

class _TextSampleTilesState extends State<TextSampleTiles> {
  bool advanced = false;

  Widget buildText(TextSample sample) {
    final extended = this.advanced || widget.onEdited != null;
    final fields = [
      if (sample.translation != null) sample.translation,
      if (extended && sample.ipa != null) '/${sample.ipa}/',
      if (extended) sample.glossed,
    ];

    final span = TextSpan(
      style: TextStyle(
        color: Colors.black54,
        fontSize: 16,
      ),
      children: [
        TextSpan(
          text: sample.plain,
          style: TextStyle(
            color: Colors.black87,
          ),
        ),
        if (fields.length > 0)
          TextSpan(
            text: ['', ...fields].join(widget.row ? ' • ' : '\n'),
          )
      ],
    );

    return widget.onEdited == null
        ? SelectableText.rich(span)
        : RichText(text: span);
  }

  void showEditor(BuildContext context, int index) {
    final samples = widget.samples ?? [];
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
      setter: widget.onEdited!,
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
          : buildText(widget.samples![index]),
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
    final tiles = Column(
      children: [
        buildTile(context, 0),
        if (widget.samples != null)
          for (var i = 1; i < widget.samples!.length; i++)
            buildTile(context, i),
      ],
    );
    return widget.onEdited == null
        ? InkWell(
            onTap: () => setState(() {
              advanced = !advanced;
            }),
            child: tiles,
          )
        : tiles;
  }
}
