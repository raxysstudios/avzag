import 'package:avzag/models/language.dart';
import 'package:avzag/modules/home/services/mapbox.dart';
import 'package:avzag/shared/extensions.dart';
import 'package:avzag/shared/utils.dart';
import 'package:avzag/shared/widgets/language_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

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
        maxZoom: 9,
        minZoom: 5,
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        plugins: [MarkerClusterPlugin()],
        swPanBoundary: LatLng(41.1, 40),
        nePanBoundary: LatLng(45, 48.1),
      ),
      layers: [
        getTileLayer(
          Theme.of(context).brightness == Brightness.dark,
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
                    duration: duration200,
                    child: Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: Tooltip(
                        message: language.name.titled,
                        preferBelow: false,
                        child: InkWell(
                          onTap: () => onToggle(language),
                          child: Padding(
                            padding: const EdgeInsets.all(2),
                            child: LanguageAvatar(
                              null,
                              url: language.flag,
                            ),
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
