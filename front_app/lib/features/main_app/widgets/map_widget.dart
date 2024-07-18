import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapWidget extends StatelessWidget {
  final MapController mapController;
  final List<Marker> markers;
  final LatLng currentPosition;

  MapWidget({
    required this.mapController,
    required this.markers,
    required this.currentPosition,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: currentPosition,
          initialZoom: 16,
          minZoom: 10,
          maxZoom: 20,
          interactionOptions: InteractionOptions(
            flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
          ),
        ),
        children: [
          TileLayer(
            urlTemplate:
                'https://api.mapbox.com/styles/v1/mapbox/streets-v11/tiles/{z}/{x}/{y}?access_token=${dotenv.env['MAPBOX_ACCESS_TOKEN']}',
          ),
          MarkerLayer(
            markers: markers,
          ),
        ],
      ),
    );
  }
}
