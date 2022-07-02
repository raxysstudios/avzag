import 'dart:math';
import 'package:avzag/store.dart';
import 'package:flutter/material.dart';

class LanguageFlag extends StatelessWidget {
  final String? language;
  final String? url;
  final double? width;
  final double? height;
  final double rotation;
  final Offset offset;
  final double scale;

  const LanguageFlag(
    this.language, {
    this.url,
    this.width,
    this.height,
    this.rotation = -pi / 4,
    this.offset = const Offset(0, 0),
    this.scale = 1,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final url = this.url ?? GlobalStore.languages[language]?.flag;
    if (url == null) return const SizedBox();
    return Transform.translate(
      offset: offset,
      child: Transform.rotate(
        angle: rotation,
        child: Transform.scale(
          scale: scale,
          child: Image.network(
            url,
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
