import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class LanguageFlag extends StatefulWidget {
  final String? flag;
  final double? width;
  final double? height;
  final double rotation;
  final Offset offset;
  final double scale;

  static final Map<String, String> urls = {};

  const LanguageFlag(
    this.flag, {
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
  String? get url => LanguageFlag.urls[widget.flag];

  @override
  void initState() {
    super.initState();
    if (url == null && widget.flag != null) {
      FirebaseStorage.instance
          .ref('flags/${widget.flag}.png')
          .getDownloadURL()
          .then(
            (u) => setState(() {
              LanguageFlag.urls[widget.flag!] = u;
            }),
          );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (url == null) return const Offstage();
    return Transform.translate(
      offset: widget.offset,
      child: Transform.rotate(
        angle: widget.rotation,
        child: Transform.scale(
          scale: widget.scale,
          child: Image.network(
            url!,
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
