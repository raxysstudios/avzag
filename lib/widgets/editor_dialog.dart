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
  final theme = Theme.of(context);
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
                icon: const Icon(Icons.delete_outlined),
                color: theme.colorScheme.error,
                splashColor: theme.colorScheme.error.withOpacity(0.1),
              ),
              Spacer(),
              TextButton.icon(
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.close_outlined),
                label: Text('Cancel'),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(theme.hintColor),
                  overlayColor: MaterialStateProperty.all(
                    theme.hintColor.withOpacity(0.1),
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
