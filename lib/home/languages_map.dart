import 'package:avzag/home/language_avatar.dart';
import 'package:avzag/home/language_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:latlong2/latlong.dart';

import 'language.dart';

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
    final theme = Theme.of(context);
    final mapStyleUrl = theme.brightness == Brightness.light
        ? '4bfb6bd9-e4e9-42b5-abfe-9f90ecb11e6b'
        : '5b319ec1-f075-4278-b743-31be8b4a0808';

    return FlutterMap(
      options: MapOptions(
        center: LatLng(43, 45),
        zoom: 5,
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        plugins: [
          MarkerClusterPlugin(),
        ],
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              'https://tile.jawg.io/$mapStyleUrl/{z}/{x}/{y}.png?access-token=6F94UuT7990iq8Z5yQpnbyujlm0Zr7bZkJwMshoaTEtYnsabLMp2EttcF6fCoW10',
          subdomains: ['a', 'b', 'c'],
          backgroundColor: theme.brightness == Brightness.light
              ? const Color(0xffcad2d3)
              : const Color(0xff191a1a),
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
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                    ),
                    child: InkWell(
                      onTap: () => onToggle(language),
                      onLongPress: () => showModalBottomSheet<void>(
                        context: context,
                        backgroundColor: Colors.transparent,
                        constraints: const BoxConstraints.tightFor(
                          height: 94,
                        ),
                        builder: (context) {
                          return LanguageCard(
                            language,
                            selected: selected,
                            onTap: () {
                              onToggle(language);
                              Navigator.pop(context);
                            },
                          );
                        },
                      ),
                      child: LanguageAvatar(
                        language.flag,
                        radius: 10,
                      ),
                    ),
                  );
                },
              ),
          ],
          builder: (context, markers) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
              child: Center(
                child: Text(
                  markers.length.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
