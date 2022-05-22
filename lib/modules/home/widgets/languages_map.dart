import 'package:avzag/models/language.dart';
import 'package:avzag/shared/utils/utils.dart';
import 'package:avzag/shared/widgets/language_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

import '../services/mapbox.dart';

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
      layers: [
        composeVectorLayer(context),
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
            for (final l in languages.where((l) => l.location != null))
              Marker(
                width: 48,
                height: 48,
                point: LatLng(
                  l.location!.latitude,
                  l.location!.longitude,
                ),
                builder: (context) {
                  final selected = this.selected.contains(l);
                  return AnimatedOpacity(
                    opacity: selected ? 1 : .5,
                    duration: const Duration(milliseconds: 250),
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Tooltip(
                        message: capitalize(l.name),
                        preferBelow: false,
                        child: InkWell(
                          onTap: () => onToggle(l),
                          child: LanguageAvatar(
                            null,
                            url: l.flag,
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
