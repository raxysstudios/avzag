import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

String? emptyValidator(String? value) {
  value = value?.trim() ?? '';
  if (value.isEmpty) return 'Cannot be empty';
}

void showEditorDialog<T>(
  BuildContext context, {
  required ValueGetter<T?> result,
  required ValueSetter<T?> callback,
  required String title,
  required List<Widget> children,
}) {
  final form = GlobalKey<FormState>();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Form(
            key: form,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Column(
              children: children,
            ),
          ),
        ),
        actions: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  callback(null);
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
                highlightColor: Colors.transparent,
                splashColor: Colors.red.shade50,
              ),
              Spacer(),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_outlined),
                label: Text('Cancel'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.blueGrey),
                  overlayColor: MaterialStateProperty.all(
                    Colors.blueGrey.shade50,
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () {
                  if (form.currentState?.validate() ?? false) {
                    Navigator.pop(context);
                    callback(result());
                  }
                },
                icon: Icon(Icons.done),
                label: Text('Save'),
              ),
            ],
          ),
        ],
      );
    },
  );
}
