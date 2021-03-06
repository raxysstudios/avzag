import 'package:bazur/shared/modals/snackbar_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void copyText(BuildContext context, String? text) async {
  if (text?.isNotEmpty ?? false) {
    await Clipboard.setData(
      ClipboardData(text: text),
    );
    showSnackbar(
      context,
      icon: Icons.content_copy_outlined,
      text: 'Copied to clipboard',
    );
  }
}

void openLink(String url) {
  launchUrl(
    Uri.parse(url),
    mode: LaunchMode.externalApplication,
  );
}

const duration200 = Duration(milliseconds: 200);
final styleNative = GoogleFonts.bitter(fontWeight: FontWeight.w600);

List<String>? json2list(Object? array) {
  return (array as Iterable<dynamic>?)
      ?.map((dynamic i) => i as String)
      .toList();
}

List<T>? listFromJson<T>(
  Object? array,
  T Function(dynamic) fromJson,
) {
  return (array as Iterable<dynamic>?)
      ?.map((dynamic i) => fromJson(i))
      .toList();
}
