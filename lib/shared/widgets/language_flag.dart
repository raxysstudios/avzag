import 'dart:math';
import 'package:flutter/material.dart';

class LanguageFlag extends StatelessWidget {
  final String? language;
  final double? width;
  final double? height;
  final double rotation;
  final Offset offset;
  final double scale;

  const LanguageFlag(
    this.language, {
    this.height = 32,
    this.width = 96,
    this.scale = 2,
    this.rotation = -pi / 4,
    this.offset = const Offset(0, 0),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: rotation,
        child: Transform.scale(
          scale: scale,
          child: Image.network(
            'https://firebasestorage.googleapis.com/v0/b/avzagapp.appspot.com/o/flags%2F$language.png?alt=media',
            repeat: ImageRepeat.repeatX,
            fit: BoxFit.contain,
            width: width,
            height: height,
          ),
        ),
      ),
    );
  }
}
