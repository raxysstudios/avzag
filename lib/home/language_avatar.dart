import 'dart:io';

import 'package:avzag/home/language_flag.dart';
import 'package:avzag/home/models.dart';
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
        backgroundImage: FileImage(
          File(docDir + flagPath(language)),
        ),
      ),
    );
  }
}
