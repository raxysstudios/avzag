import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

TileLayerOptions getTileLayer([bool isDark = false]) {
  const token =
      'pk.eyJ1IjoicmF4eXNzdHVkaW9zIiwiYSI6ImNsM2RoamIzaTAxbWYzZG4xNTJ4MWhoOGkifQ.bk09KPfb2EQuwtcxU-INrQ';
  final style =
      isDark ? 'cl3hf82ox003315qg72h9wx5y' : 'cl3g6sr4x004o14o2ywap9fhb';
  final background = isDark ? const Color(0xff3b3b3b) : const Color(0xfff7f8f8);
  return TileLayerOptions(
    urlTemplate:
        'https://api.mapbox.com/styles/v1/raxysstudios/$style/tiles/{z}/{x}/{y}@2x?access_token=$token',
    subdomains: ['a', 'b', 'c'],
    backgroundColor: background,
    tileSize: 512,
    zoomOffset: -1,
  );
}
