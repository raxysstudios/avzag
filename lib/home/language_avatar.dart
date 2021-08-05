import 'package:avzag/home/language.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'language_flag.dart';
import 'store.dart';

class LanguageAvatar extends StatefulWidget {
  late final Language language;
  final Widget? child;
  final double radius;
  static const double R = 12;

  LanguageAvatar(
    String language, {
    this.child,
    this.radius = 1.5 * R,
  }) {
    this.language = HomeStore.languages[language]!;
  }

  @override
  _LanguageAvatarState createState() => _LanguageAvatarState();
}

class _LanguageAvatarState extends State<LanguageAvatar> {
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
    if (url == null) return Icon(Icons.flag_outlined);
    return Transform.scale(
      scale: widget.radius / LanguageAvatar.R,
      child: CircleAvatar(
        radius: LanguageAvatar.R,
        backgroundImage: NetworkImage(url!),
      ),
    );
  }
}
