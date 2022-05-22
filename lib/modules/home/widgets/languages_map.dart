import 'package:avzag/models/language.dart';
import 'package:avzag/modules/home/widgets/theme_provider.dart' as my_theme;
import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/language_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart' as vector_theme;

class LanguagesMap extends StatelessWidget {
  const LanguagesMap({
    required this.languages,
    required this.selected,
    required this.onToggle,
    Key? key,
  }) : super(key: key);

  final List<Language> languages;
  final Set<Language> selected;
  final ValueSetter<Language> onToggle;

  VectorTileProvider _cachingTileProvider(String url) {
    return MemoryCacheVectorTileProvider(
      delegate: NetworkVectorTileProvider(
        urlTemplate: url,
        maximumZoom: 14,
      ),
      maxSizeBytes: 1024 * 1024 * 2,
    );
  }

  vector_theme.Theme _mapTheme(BuildContext context) {
    if (MediaQuery.of(context).platformBrightness == Brightness.dark) {
      return my_theme.ProvideMyTheme.monodarkTheme();
    } else {
      return my_theme.ProvideMyTheme.monowhiteTheme();
    }
  }

  @override
  Widget build(context) {
    const String token =
        'pk.eyJ1IjoicmF4eXNzdHVkaW9zIiwiYSI6ImNsM2RoamIzaTAxbWYzZG4xNTJ4MWhoOGkifQ.bk09KPfb2EQuwtcxU-INrQ';
    return FlutterMap(
      options: MapOptions(
        center: LatLng(43, 45),
        zoom: 5,
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        plugins: [
          MarkerClusterPlugin(),
          VectorMapTilesPlugin(),
        ],
      ),
      layers: <LayerOptions>[
        VectorTileLayerOptions(
          theme: _mapTheme(context),
          tileProviders: TileProviders(
            {
              'composite': _cachingTileProvider(
                  'https://api.mapbox.com/v4/mapbox.mapbox-streets-v8/1/0/0.mvt?access_token=$token')
            },
          ),
        ),
        MarkerClusterLayerOptions(
          size: const Size.square(48),
          showPolygon: false,
          maxClusterRadius: 32,
          fitBoundsOptions: const FitBoundsOptions(
            padding: EdgeInsets.all(128),
          ),
          animationsOptions: const AnimationsOptions(
            zoom: Duration(milliseconds: 250),
            fitBound: Duration(milliseconds: 250),
            centerMarker: Duration(milliseconds: 250),
            spiderfy: Duration(milliseconds: 250),
          ),
          centerMarkerOnClick: false,
          markers: [
            for (final language in languages.where((l) => l.location != null))
              Marker(
                width: 48,
                height: 48,
                point: LatLng(
                  language.location!.latitude,
                  language.location!.longitude,
                ),
                // anchorPos: AnchorPos.align(AnchorAlign.bottom),
                builder: (context) {
                  final selected = this.selected.contains(language);
                  return AnimatedOpacity(
                    opacity: selected ? 1 : .5,
                    duration: const Duration(milliseconds: 250),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Tooltip(
                        message: capitalize(language.name),
                        preferBelow: false,
                        child: InkWell(
                          onTap: () => onToggle(language),
                          child: LanguageAvatar(
                            null,
                            url: language.flag,
                            radius: 10,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
          ],
          builder: (context, markers) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: Opacity(
                    opacity: .5,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                    ),
                  ),
                ),
                Text(
                  markers.length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
