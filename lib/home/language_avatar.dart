import 'package:avzag/home/language.dart';
import 'package:avzag/home/store.dart';
import 'package:flutter/material.dart';

class LanguageAvatar extends StatelessWidget {
  final Language language;
  final double radius;
  static const double R = 12;

  const LanguageAvatar(
    this.language, {
    this.radius = 1.5 * R,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: radius / R,
      child: CircleAvatar(
        radius: R,
        backgroundImage: NetworkImage(language.flagUrl),
      ),
    );
  }
}
