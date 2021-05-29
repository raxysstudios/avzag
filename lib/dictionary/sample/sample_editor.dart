import 'package:avzag/dictionary/sample/sample.dart';
import 'package:flutter/material.dart';

class SampleEditor extends StatefulWidget {
  final Sample value;
  final ValueSetter<Sample> setter;
  final bool translation;
  SampleEditor(
    this.value,
    this.setter, {
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
    sample = Sample.fromJson(widget.value.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextFormField(
            initialValue: sample.plain,
            decoration: InputDecoration(labelText: "Plain text"),
            validator: (v) =>
                v?.isEmpty ?? false ? 'Please enter some text' : null,
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
              if (formKey.currentState!.validate()) widget.setter(sample);
            },
            icon: Icon(Icons.save_outlined),
            label: Text("Save"),
          ),
        ],
      ),
    );
  }
}
