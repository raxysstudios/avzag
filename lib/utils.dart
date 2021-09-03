import 'package:flutter/services.dart';

String capitalize(String value) => value
    .split(' ')
    .where((w) => w.length > 0)
    .map((w) => w[0].toUpperCase() + w.substring(1))
    .join(' ');

String? prettyTags(
  Iterable<String>? tags, {
  String separator = ' • ',
  bool capitalized = true,
}) {
  if (tags == null) return null;
  final text = tags.join(separator);
  return capitalized ? capitalize(text) : text;
}

List<String>? json2list(Object? array) {
  return (array as Iterable<dynamic>?)?.map((i) => i as String).toList();
}

List<T>? listFromJson<T>(
  Object? array,
  T Function(dynamic) fromJson,
) {
  return (array as Iterable<dynamic>?)?.map((i) => fromJson(i)).toList();
}

class LowerCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue _,
    TextEditingValue value,
  ) {
    return TextEditingValue(
      text: value.text.toLowerCase(),
      selection: value.selection,
    );
  }
}

T? orNull<T>(bool check, T? value) => check ? value : null;
