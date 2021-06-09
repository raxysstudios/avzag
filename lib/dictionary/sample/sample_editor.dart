import 'package:avzag/dictionary/sample/sample.dart';
import 'package:flutter/material.dart';

class SampleEditor extends StatefulWidget {
  final Sample sample;
  final String title;
  final bool translation;
  SampleEditor(
    this.sample, {
    this.title = "Sample editor",
    this.translation = true,
  });

  @override
  _SampleEditorState createState() => _SampleEditorState();
}

class _SampleEditorState extends State<SampleEditor> {
  late Sample sample;
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    sample = Sample.fromJson(widget.sample.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      title: Text(widget.title),
      contentPadding: const EdgeInsets.all(16),
      children: [
        Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                initialValue: sample.plain,
                decoration: InputDecoration(labelText: "Plain text"),
                validator: (v) =>
                    v?.isEmpty ?? false ? 'Cannot be empty' : null,
                onChanged: (s) => sample.plain = s,
              ),
              TextFormField(
                initialValue: sample.ipa,
                decoration: InputDecoration(labelText: "IPA glossed text"),
                onChanged: (s) => sample.ipa = s,
              ),
              TextFormField(
                initialValue: sample.glossed,
                decoration: InputDecoration(labelText: "Leipzig glossed text"),
                onChanged: (s) => sample.glossed = s,
              ),
              if (widget.translation)
                TextFormField(
                  initialValue: sample.translation,
                  decoration: InputDecoration(labelText: "Translation"),
                  onChanged: (s) => sample.translation = s,
                ),
              OutlinedButton.icon(
                onPressed: () {
                  if (formKey.currentState!.validate())
                    Navigator.pop(context, sample);
                },
                icon: Icon(Icons.save_outlined),
                label: Text("Save"),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
