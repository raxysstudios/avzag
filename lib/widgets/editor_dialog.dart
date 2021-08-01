import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditorDialogResult<T> {
  T? value;
  EditorDialogResult(this.value);
}

Future<EditorDialogResult<T>?> showEditorDialog<T>(
  BuildContext context, {
  required EditorDialogResult<T> result,
  required ValueSetter<T?> setter,
  required String title,
  required Widget content,
}) {
  return showDialog<EditorDialogResult<T>>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(title),
        content: content,
        actions: [
          Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                  setter(null);
                },
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.red,
                ),
              ),
              Spacer(),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('CANCEL'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  setter(result.value);
                },
                child: Text('SAVE'),
              ),
            ],
          ),
        ],
      );
    },
  );
}
