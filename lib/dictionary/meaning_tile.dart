import 'package:avzag/widgets/snackbar_manager.dart';

import 'use.dart';
import 'package:avzag/utils.dart';
import 'package:flutter/material.dart';
import 'package:avzag/widgets/editor_dialog.dart';

class MeaningTile extends StatelessWidget {
  final Use use;
  final ValueSetter<Use?>? onEdited;

  const MeaningTile(
    this.use, {
    Key? key,
    this.onEdited,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).textTheme;
    return ListTile(
      minVerticalPadding: 12,
      leading: const Icon(Icons.lightbulb_outline),
      title: RichText(
        maxLines: 1,
        text: TextSpan(
          style: theme.subtitle1,
          children: [
            TextSpan(
              text: capitalize(use.term),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (use.definition != null) TextSpan(text: ' ' + use.definition!),
          ],
        ),
      ),
      subtitle: onEdited != null && (use.aliases?.isNotEmpty ?? false)
          ? Text(
              prettyTags(use.aliases, separator: ', ')!,
              maxLines: 1,
            )
          : null,
      onTap: onEdited == null
          ? null
          : () => showEditor(
                context: context,
                use: use,
                callback: onEdited!,
              ),
      onLongPress: onEdited == null
          ? () => copyText(
                context,
                [
                  use.term,
                  if (use.definition != null) use.definition,
                ].join(' '),
              )
          : null,
    );
  }

  static void showEditor({
    required BuildContext context,
    Use? use,
    required ValueSetter<Use?> callback,
  }) {
    final result = use == null ? Use(term: '') : Use.fromJson(use.toJson());
    var aliases = result.aliases?.join(' ');
    showEditorDialog(
      context,
      result: () {
        result.aliases =
            aliases?.split(' ').where((e) => e.isNotEmpty).toList();
        return result;
      },
      callback: callback,
      title: 'Edit entry concept',
      children: [
        TextFormField(
          autofocus: true,
          initialValue: result.term,
          onChanged: (text) {
            result.term = text.trim();
          },
          decoration: const InputDecoration(
            labelText: 'General term',
          ),
          validator: emptyValidator,
          inputFormatters: [LowerCaseTextFormatter()],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: result.definition,
          onChanged: (text) {
            result.definition = text.trim();
          },
          decoration: const InputDecoration(
            labelText: 'Specific definition',
          ),
          inputFormatters: [LowerCaseTextFormatter()],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: aliases,
          onChanged: (text) {
            aliases = text.trim();
          },
          decoration: const InputDecoration(
            labelText: 'Aliases, space-separated (for search only)',
          ),
          inputFormatters: [LowerCaseTextFormatter()],
        ),
      ],
    );
  }
}
