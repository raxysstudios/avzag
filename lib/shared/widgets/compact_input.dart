import 'package:flutter/material.dart';

String? _emptyValidator(String? value) {
  value = value?.trim() ?? '';
  return value.isEmpty ? "     Can't be empty!" : null;
}

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
        maxLines: multiline ? null : 1,
        initialValue: initial,
        validator: noEmpty ? _emptyValidator : null,
        onChanged: (s) {
          s = s.trim();
          if (lowercase) s = s.toLowerCase();
          onChanged(s);
        },
      ),
    );
  }
}
