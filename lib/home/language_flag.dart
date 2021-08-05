import 'dart:math';
import 'package:avzag/home/language.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'store.dart';

class LanguageFlag extends StatefulWidget {
  late final Language language;
  final double width;
  final double height;
  final double rotation;
  final Offset offset;
  final double scale;

  static final Map<String, String> urls = {};

  LanguageFlag(
    String language, {
    this.width = 16,
    this.height = 4,
    this.rotation = -pi / 4,
    this.offset = const Offset(0, 0),
    this.scale = 18,
  }) {
    this.language = HomeStore.languages[language]!;
  }

  @override
  _LanguageFlagState createState() => _LanguageFlagState();
}

class _LanguageFlagState extends State<LanguageFlag> {
  String? get url => LanguageFlag.urls[widget.language.name];

  @override
  void initState() {
    super.initState();
    if (url == null)
      FirebaseStorage.instance
          .ref('flags/${widget.language.flag}.png')
          .getDownloadURL()
          .then(
            (u) => setState(() {
              LanguageFlag.urls[widget.language.name] = u;
            }),
          );
  }

  @override
  Widget build(BuildContext context) {
    if (url == null) return Offstage();
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
              url!,
              repeat: ImageRepeat.repeatX,
              errorBuilder: (
                context,
                exception,
                stackTrace,
              ) =>
                  Container(),
            ),
          ),
        ),
      ),
    );
  }
}
