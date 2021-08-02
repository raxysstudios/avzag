import 'use.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'package:avzag/widgets/editor_dialog.dart';

class ConceptTile extends StatelessWidget {
  final Use use;
  final ValueSetter<List<String?>?>? onEdited;

  const ConceptTile(
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
          : () {
              final result = [
                use.term,
                use.definition,
              ];
              showEditorDialog(
                context,
                result: () => result,
                callback: onEdited!,
                title: 'Edit entry concept',
                content: SingleChildScrollView(
                  child: Column(
                    children: [
                      TextFormField(
                        initialValue: use.term,
                        onChanged: (text) {
                          result[0] = text.trim();
                        },
                        decoration: InputDecoration(
                          labelText: 'General term',
                        ),
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
              );
            },
    );
  }
}
