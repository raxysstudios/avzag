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
    final result = use == null ? Use(term: '') : Use.fromJson(use.toJson());
    showEditorDialog(
      context,
      result: () => result,
      callback: callback,
      title: 'Edit entry concept',
      children: [
        TextFormField(
          autofocus: true,
          initialValue: result.term,
          onChanged: (text) {
            result.term = text.trim();
          },
          decoration: InputDecoration(
            labelText: 'General term',
          ),
          validator: emptyValidator,
        ),
        SizedBox(height: 8),
        TextFormField(
          initialValue: result.definition,
          onChanged: (text) {
            result.definition = text.trim();
          },
          decoration: InputDecoration(
            labelText: 'Specific definition',
          ),
        ),
      ],
    );
  }
}
