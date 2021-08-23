import 'dart:math';
import 'package:avzag/global_store.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class LanguageFlag extends StatefulWidget {
  late final String? flag;
  final double width;
  final double height;
  final double rotation;
  final Offset offset;
  final double scale;

  static final Map<String, String> urls = {};

  LanguageFlag(
    String? language, {
    String? flag,
    this.width = 16,
    this.height = 4,
    this.rotation = -pi / 4,
    this.offset = const Offset(0, 0),
    this.scale = 18,
  }) {
    this.flag = flag ?? GlobalStore.catalogue[language]?.flag;
  }

  @override
  _LanguageFlagState createState() => _LanguageFlagState();
}

class _LanguageFlagState extends State<LanguageFlag> {
  String? get url => LanguageFlag.urls[widget.flag];

  @override
  void initState() {
    super.initState();
    if (url == null && widget.flag != null)
      FirebaseStorage.instance
          .ref('flags/${widget.flag}.png')
          .getDownloadURL()
          .then(
            (u) => setState(() {
              LanguageFlag.urls[widget.flag!] = u;
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
