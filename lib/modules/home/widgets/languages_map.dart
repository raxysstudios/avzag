import 'package:avzag/models/language.dart';
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

  VectorTileProvider _cachingTileProvider(String urlTemplate) {
    return MemoryCacheVectorTileProvider(
        delegate: NetworkVectorTileProvider(
            urlTemplate: urlTemplate,
            // this is the maximum zoom of the provider, not the
            // maximum of the map. vector tiles are rendered
            // to larger sizes to support higher zoom levels
            maximumZoom: 14),
        maxSizeBytes: 1024 * 1024 * 2);
  }

  @override
  Widget build(context) {
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
          theme: vector_theme.ProvidedThemes.lightTheme(),
          tileProviders: TileProviders(
            {
              'openmaptiles': _cachingTileProvider(
                  'https://tiles.stadiamaps.com/data/openmaptiles/{z}/{x}/{y}.pbf?api_key=d441798a-57bb-47df-bff7-64f1c314ef07')
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
