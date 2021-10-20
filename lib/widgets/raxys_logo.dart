import 'package:flutter/material.dart';

class RaxysLogo extends StatelessWidget {
  const RaxysLogo({
    this.size = 256,
    Key? key,
  }) : super(key: key);

  final double size;

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
