import 'package:flutter/material.dart';

class LanguageAvatar extends StatelessWidget {
  final String? language;
  final String? url;
  final double? radius;

  const LanguageAvatar(
    this.language, {
    this.url,
    this.radius,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      foregroundImage: NetworkImage(
        'https://firebasestorage.googleapis.com/v0/b/avzagapp.appspot.com/o/flags%2F$language.png?alt=media',
      ),
      backgroundColor: Colors.transparent,
    );
  }
}
