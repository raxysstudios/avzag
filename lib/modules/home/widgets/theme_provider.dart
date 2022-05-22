import 'package:avzag/modules/home/widgets/monodark_theme_data.dart';
import 'package:avzag/modules/home/widgets/monowhite_theme_data.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart';

class ProvideMyTheme {
  ProvideMyTheme._();

  static Theme monowhiteTheme({Logger? logger}) =>
      ThemeReader(logger: logger).read(monowhiteThemeData());
  static Theme monodarkTheme({Logger? logger}) =>
      ThemeReader(logger: logger).read(monodarkThemeData());
}
