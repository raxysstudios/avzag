import 'package:avzag/home/language.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class LanguageAvatar extends StatefulWidget {
  final Language language;
  final double radius;
  static const double R = 12;

  const LanguageAvatar(
    this.language, {
    this.radius = 1.5 * R,
  });

  @override
  _LanguageAvatarState createState() => _LanguageAvatarState();
}

class _LanguageAvatarState extends State<LanguageAvatar> {
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
    if (widget.language.flagUrl == null)
      return Icon(Icons.auto_awesome_outlined);
    return Transform.scale(
      scale: widget.radius / LanguageAvatar.R,
      child: CircleAvatar(
        radius: LanguageAvatar.R,
        backgroundImage: NetworkImage(widget.language.flagUrl!),
      ),
    );
  }
}
