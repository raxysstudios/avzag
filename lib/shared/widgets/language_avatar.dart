import 'package:avzag/store.dart';
import 'package:flutter/material.dart';

class LanguageAvatar extends StatefulWidget {
  final String? language;
  final String? url;
  final double radius;
  static const double R = 12;

  const LanguageAvatar(
    this.language, {
    this.url,
    this.radius = 1.5 * R,
    Key? key,
  }) : super(key: key);

  @override
  State<LanguageAvatar> createState() => _LanguageAvatarState();
}

class _LanguageAvatarState extends State<LanguageAvatar> {
  @override
  Widget build(BuildContext context) {
    final url = widget.url ?? GlobalStore.languages[widget.language]?.flag;
    if (url == null) return const Icon(Icons.flag_rounded);
    return Transform.scale(
      scale: widget.radius / LanguageAvatar.R,
      child: CircleAvatar(
        radius: LanguageAvatar.R,
        backgroundImage: NetworkImage(url),
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
