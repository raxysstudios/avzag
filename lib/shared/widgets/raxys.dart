import 'package:flutter/material.dart';

class Raxys extends StatelessWidget {
  const Raxys({
    this.size = 24,
    this.opacity = .1,
    this.scale = 7,
    Key? key,
  }) : super(key: key);

  final double scale;
  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Transform.scale(
        scale: scale,
        child: Opacity(
          opacity: opacity,
          child: ColorFiltered(
            colorFilter: ColorFilter.mode(
              Theme.of(context).brightness == Brightness.light
                  ? Colors.black
                  : Colors.white,
              BlendMode.modulate,
            ),
            child: Image.asset(
              'assets/raxys.png',
              isAntiAlias: true,
              filterQuality: FilterQuality.high,
            ),
          ),
        ),
      ),
    );
  }
}
