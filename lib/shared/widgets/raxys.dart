import 'package:flutter/material.dart';

class Raxys extends StatelessWidget {
  const Raxys({
    this.size = 24,
    this.opacity = 1,
    this.scale = 1,
    Key? key,
  }) : super(key: key);

  final double scale;
  final double size;
  final double opacity;

  Color getColor(BuildContext context) {
    final invert = Theme.of(context).brightness == Brightness.light;
    final color = invert ? Colors.black : Colors.white;
    return color.withOpacity(opacity);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.square(
      dimension: size,
      child: Transform.scale(
        scale: scale,
        child: ColorFiltered(
          colorFilter: ColorFilter.mode(
            getColor(context),
            BlendMode.modulate,
          ),
          child: Image.asset(
            'assets/raxys.png',
            isAntiAlias: true,
            filterQuality: FilterQuality.high,
          ),
        ),
      ),
    );
  }
}
