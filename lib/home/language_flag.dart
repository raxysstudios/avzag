import 'dart:math';
import 'package:avzag/home/language.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class LanguageFlag extends StatefulWidget {
  final Language language;
  final double width;
  final double height;
  final double rotation;
  final Offset offset;
  final double scale;

  const LanguageFlag(
    this.language, {
    this.width = 16,
    this.height = 4,
    this.rotation = -pi / 4,
    this.offset = const Offset(0, 0),
    this.scale = 18,
  });

  @override
  _LanguageFlagState createState() => _LanguageFlagState();
}

class _LanguageFlagState extends State<LanguageFlag> {
  @override
  void initState() {
    super.initState();
    if (widget.language.flagUrl == null)
      FirebaseStorage.instance
          .ref('flags/${widget.language.flag}.png')
          .getDownloadURL()
          .then(
            (u) => setState(() {
              widget.language.flagUrl = u;
            }),
          );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.language.flagUrl == null) return Offstage();
    return Container(
      width: widget.width,
      height: widget.height,
      child: Transform.translate(
        offset: widget.offset,
        child: Transform.rotate(
          angle: widget.rotation,
          child: Transform.scale(
            scale: widget.scale,
            child: Image.network(
              widget.language.flagUrl!,
              repeat: ImageRepeat.repeatX,
              errorBuilder: (
                BuildContext context,
                Object exception,
                StackTrace? stackTrace,
              ) =>
                  Container(),
            ),
          ),
        ),
      ),
    );
  }
}
