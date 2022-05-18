import 'package:flutter/material.dart';

import '../utils/utils.dart';
import 'modals/editor_dialog.dart';

class CompactInput extends StatelessWidget {
  const CompactInput(
    this.icon,
    this.label,
    this.initial,
    this.onChanged, {
    this.lowercase = true,
    this.noEmpty = false,
    this.multiline = false,
    this.trailing,
    Key? key,
  }) : super(key: key);

  final IconData? icon;
  final String label;
  final String? initial;
  final ValueSetter<String> onChanged;
  final bool lowercase;
  final bool noEmpty;
  final Widget? trailing;
  final bool multiline;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 0,
      visualDensity: const VisualDensity(
        vertical: VisualDensity.minimumDensity,
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8),
      trailing: trailing,
      title: TextFormField(
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: label,
          isDense: true,
          border: InputBorder.none,
        ),
        maxLines: multiline ? 0 : null,
        initialValue: initial,
        validator: noEmpty ? emptyValidator : null,
        inputFormatters: lowercase ? [LowerCaseTextFormatter()] : null,
        onChanged: (s) => onChanged(s.trim()),
      ),
    );
  }
}
