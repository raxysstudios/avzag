import 'package:avzag/store.dart';
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
    final url = this.url ?? GlobalStore.languages[language]?.flag;
    if (url == null) return const Icon(Icons.flag_outlined);
    return CircleAvatar(
      radius: radius,
      backgroundImage: NetworkImage(url),
      backgroundColor: Colors.transparent,
    );
  }
}
