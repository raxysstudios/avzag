import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart' as vector_theme;

typedef _MapTheme = vector_theme.Theme;

var themesLoaded = false;
late _MapTheme _light;
late _MapTheme _dark;

Future<void> initThemes() async {
  if (themesLoaded) return;

  Future<_MapTheme> loadTheme(String theme) async {
    final doc = await rootBundle.loadString('assets/mapbox/$theme.json');
    final data = json.decode(doc) as Map<String, dynamic>;
    return vector_theme.ThemeReader().read(data);
  }

  _light = await loadTheme('light');
  _dark = await loadTheme('dark');
  themesLoaded = true;
}

VectorTileProvider _cachingTileProvider() {
  const base =
      'https://api.mapbox.com/v4/mapbox.mapbox-streets-v8/{z}/{x}/{y}.mvt';
  const token =
      'pk.eyJ1IjoicmF4eXNzdHVkaW9zIiwiYSI6ImNsM2RoamIzaTAxbWYzZG4xNTJ4MWhoOGkifQ.bk09KPfb2EQuwtcxU-INrQ';
  const style = 'mapbox://styles/raxysstudios/cl3g6sr4x004o14o2ywap9fhb';
  const url = '$base?style=$style@00&access_token=$token';
  return MemoryCacheVectorTileProvider(
    delegate: NetworkVectorTileProvider(
      urlTemplate: url,
      maximumZoom: 14,
    ),
    maxSizeBytes: 1024 * 1024 * 2,
  );
}

VectorTileLayerOptions composeVectorLayer(BuildContext context) {
  return VectorTileLayerOptions(
    theme: Theme.of(context).brightness == Brightness.light ? _light : _dark,
    tileProviders: TileProviders(
      {'composite': _cachingTileProvider()},
    ),
  );
}
