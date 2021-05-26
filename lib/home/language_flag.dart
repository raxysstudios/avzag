import 'dart:math';
import 'package:avzag/home/language.dart';
import 'package:flutter/material.dart';

class LanguageFlag extends StatelessWidget {
  const LanguageFlag(
    this.language, {
    this.offset = const Offset(0, 0),
    this.scale = 18,
  });
  final Language language;
  final Offset offset;
  final double scale;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 16,
      height: 4,
      child: Transform.translate(
        offset: offset,
        child: Transform.rotate(
          angle: -pi / 4,
          child: Transform.scale(
            scale: scale,
            // child: Image.asset(
            //   language,
            //   repeat: ImageRepeat.repeatX,
            //   // fit: BoxFit.contain,
            //   errorBuilder: (
            //     BuildContext context,
            //     Object exception,
            //     StackTrace? stackTrace,
            //   ) =>
            //       Container(),
            // ),
          ),
        ),
      ),
    );
  }
}
