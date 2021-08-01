import 'use.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';

class ConceptTile extends StatelessWidget {
  final Use use;
  final ValueSetter<List<String>?>? onEdited;

  ConceptTile(this.use, {this.onEdited});

  void edit(BuildContext context) {
    showDialog<List<String>>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        final concept = [use.term, use.definition];
        return AlertDialog(
          title: Text('Edit entry concept'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  initialValue: use.term,
                  onChanged: (text) {
                    concept[0] = text;
                  },
                ),
                SizedBox(height: 8),
                TextFormField(
                  initialValue: use.definition,
                  onChanged: (text) {
                    concept[1] = text;
                  },
                ),
              ],
            ),
          ),
          actions: [
            Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                  ),
                ),
                Spacer(),
                TextButton(
                  onPressed: () => Navigator.pop(
                    context,
                    [use.term, use.definition],
                  ),
                  child: Text('CANCEL'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, concept),
                  child: Text('SAVE'),
                ),
              ],
            ),
          ],
        );
      },
    ).then((value) => onEdited!(value));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
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
      onTap: onEdited == null ? null : () => edit(context),
    );
  }
}
