import 'package:avzag/global_store.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'language_flag.dart';

class LanguageAvatar extends StatefulWidget {
  late final String? flag;
  final double radius;
  static const double R = 12;

  LanguageAvatar(
    String? language, {
    String? flag,
    this.radius = 1.5 * R,
  }) {
    this.flag = flag ?? GlobalStore.catalogue[language]?.flag;
  }

  @override
  _LanguageAvatarState createState() => _LanguageAvatarState();
}

class _LanguageAvatarState extends State<LanguageAvatar> {
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
