import 'use.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'package:avzag/widgets/editor_dialog.dart';

class MeaningTile extends StatelessWidget {
  final Use use;
  final ValueSetter<Use?>? onEdited;

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
      onTap: onEdited == null
          ? null
          : () => showEditor(
                context: context,
                use: use,
                callback: onEdited!,
              ),
    );
  }

  static void showEditor({
    required BuildContext context,
    Use? use,
    required ValueSetter<Use?> callback,
  }) {
    final form = GlobalKey<FormState>();
    final value = use == null ? Use(term: '') : Use.fromJson(use.toJson());
    showEditorDialog(
      context,
      result: () => value,
      callback: callback,
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
                initialValue: value.term,
                onChanged: (text) {
                  value.term = text.trim();
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
                initialValue: value.definition,
                onChanged: (text) {
                  value.definition = text.trim();
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
