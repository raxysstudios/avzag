import 'package:flutter/material.dart';

class AvzagLogo extends StatelessWidget {
  final double size;
  const AvzagLogo(this.size, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      child: Theme.of(context).brightness == Brightness.dark
          ? Image.asset('assets/splash_dark.png')
          : Image.asset('assets/splash_light.png'),
    );
  }
}
