import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class EditorDialogResult<T> {
  T? value;
  EditorDialogResult(this.value);
}

void showEditorDialog<T>(
  BuildContext context, {
  required EditorDialogResult<T> result,
  required ValueSetter<T?> setter,
  required String title,
  required Widget content,
}) =>
    showDialog(
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
                    Navigator.pop(context);
                    setter(result.value);
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
