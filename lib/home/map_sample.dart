import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final selected = {'Kaitag'};
  final lects = {
    'Iron': [42.865209, 44.245623],
    'Digor': [43.172488, 43.871052],
    'Kabardian': [43.762647, 42.769419],
    'Kaitag': [42.082736, 47.822142]
  };

  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(51.5, -0.09),
        zoom: 13.0,
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate:
              'https://tile.jawg.io/jawg-light/{z}/{x}/{y}.png?access-token=6F94UuT7990iq8Z5yQpnbyujlm0Zr7bZkJwMshoaTEtYnsabLMp2EttcF6fCoW10',
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: [
            for (final entry in lects.entries)
              Marker(
                width: 128,
                height: 128,
                point: LatLng(entry.value[0], entry.value[1]),
                builder: (ctx) => Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 32),
                    const SizedBox(
                      height: 8,
                      child: Icon(
                        Icons.keyboard_arrow_up,
                        size: 32,
                      ),
                    ),
                    TextButton(
                      child: Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: selected.contains(entry.key)
                              ? Colors.blue
                              : Colors.black,
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: selected.contains(entry.key)
                                  ? Colors.white
                                  : Colors.black45,
                            ),
                          ],
                        ),
                      ),
                      onPressed: () => setState(
                        () {
                          if (selected.contains(entry.key)) {
                            selected.remove(entry.key);
                          } else {
                            selected.add(entry.key);
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }
}
