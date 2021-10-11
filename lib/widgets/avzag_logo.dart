import 'package:flutter/material.dart';

class AvzagLogo extends StatelessWidget {
  final double size;
  const AvzagLogo(this.size, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: Image.asset(
        Theme.of(context).brightness == Brightness.dark
            ? 'assets/splash_dark.png'
            : 'assets/splash_light.png',
        isAntiAlias: true,
        filterQuality: FilterQuality.high,
      ),
    );
  }
}
