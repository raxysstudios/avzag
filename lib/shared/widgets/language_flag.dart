import 'dart:math';
import 'package:avzag/global_store.dart';
import 'package:flutter/material.dart';

class LanguageFlag extends StatefulWidget {
  final String? language;
  final double? width;
  final double? height;
  final double rotation;
  final Offset offset;
  final double scale;

  const LanguageFlag(
    this.language, {
    Key? key,
    this.width,
    this.height,
    this.rotation = -pi / 4,
    this.offset = const Offset(0, 0),
    this.scale = 1,
  }) : super(key: key);

  @override
  State<LanguageFlag> createState() => _LanguageFlagState();
}

class _LanguageFlagState extends State<LanguageFlag> {
  @override
  Widget build(BuildContext context) {
    final url = GlobalStore.languages[widget.language]?.flag;
    if (url == null) return SizedBox();
    return Transform.translate(
      offset: widget.offset,
      child: Transform.rotate(
        angle: widget.rotation,
        child: Transform.scale(
          scale: widget.scale,
          child: Image.network(
            url,
            repeat: ImageRepeat.repeatX,
            fit: BoxFit.contain,
            width: widget.width,
            height: widget.height,
          ),
        ),
      ),
    );
  }
}
