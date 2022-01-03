import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  List<bool> selected = [true, false, false, false];
  List<String> lects = ['Iron', 'Digor', 'Kabardian', 'Temirgoi'];

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
            for (var i = 0; i < lects.length; i++)
              Marker(
                width: 128,
                height: 128,
                point: LatLng(i * 5.0, i * 5.0),
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
                        lects[i],
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: selected[i] ? Colors.blue : Colors.black,
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color:
                                  selected[i] ? Colors.white : Colors.black45,
                            ),
                          ],
                        ),
                      ),
                      onPressed: () =>
                          setState(() => selected[i] = !selected[i]),
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
