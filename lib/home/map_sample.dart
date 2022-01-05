import 'package:avzag/home/language_card.dart';
import 'package:avzag/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import 'language.dart';

class MapSample extends StatelessWidget {
  const MapSample({
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
        MarkerLayerOptions(
          markers: [
            for (final language in languages.where((l) => l.location != null))
              Marker(
                width: 160,
                height: 48,
                point: LatLng(
                  language.location!.latitude,
                  language.location!.longitude,
                ),
                anchorPos: AnchorPos.align(AnchorAlign.bottom),
                builder: (context) {
                  final selected = this.selected.contains(language);
                  return Stack(
                    children: [
                      const Align(
                        alignment: Alignment.topCenter,
                        child: Icon(Icons.arrow_drop_up_rounded),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: TextButton(
                          child: Text(
                            capitalize(language.name),
                            style: TextStyle(
                              color: selected
                                  ? theme.colorScheme.primary
                                  : theme.textTheme.bodyText1?.color,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          onPressed: () => onToggle(language),
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
                        ),
                      ),
                    ],
                  );
                },
              ),
          ],
        ),
      ],
    );
  }
}
