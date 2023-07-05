import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_network/home.dart';

class MapPage extends StatelessWidget {
  void _nextPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            _nextPage(context, HomePage());
          },
        ),
      ),
      body: FlutterMap(
        options: MapOptions(
          center: LatLng(44.8378, -0.5792),
          zoom: 13.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: ['a', 'b', 'c'],
          ),
          MarkerLayerOptions(
            markers: [
              Marker(
                width: 40.0,
                height: 40.0,
                point: LatLng(44.8378, -0.5792), // Remplacez ces coordonnées par la position de l'utilisateur
                builder: (ctx) => Container(
                  child: Icon(
                    Icons.location_on,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
