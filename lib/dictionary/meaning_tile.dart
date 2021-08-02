import 'use.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'package:avzag/widgets/editor_dialog.dart';

class MeaningTile extends StatelessWidget {
  final Use use;
  final ValueSetter<List<String?>?>? onEdited;

  const MeaningTile(
    this.use, {
    this.onEdited,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 12,
      leading: Icon(Icons.lightbulb_outline),
      title: Text(
        capitalize(use.term),
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
        ),
      ),
      subtitle: use.definition == null
          ? null
          : Text(
              use.definition!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.normal,
              ),
            ),
      onTap: onEdited == null ? null : () => showEditor(context),
    );
  }

  void showEditor(BuildContext context) {
    final form = GlobalKey<FormState>();
    final result = [
      use.term,
      use.definition,
    ];
    showEditorDialog(
      context,
      result: () => result,
      callback: onEdited!,
      validator: () => form.currentState?.validate() ?? false,
      title: 'Edit entry concept',
      content: SingleChildScrollView(
        child: Form(
          key: form,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                initialValue: use.term,
                onChanged: (text) {
                  result[0] = text.trim();
                },
                decoration: InputDecoration(
                  labelText: 'General term',
                ),
                validator: (value) {
                  value = value?.trim() ?? '';
                  if (value.isEmpty) return 'Cannot be empty';
                },
              ),
              SizedBox(height: 8),
              TextFormField(
                initialValue: use.definition,
                onChanged: (text) {
                  result[1] = text.trim();
                },
                decoration: InputDecoration(
                  labelText: 'Specific definition',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
