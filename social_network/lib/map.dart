import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:social_network/home.dart';

class MapPage extends StatefulWidget {
  @override
  
  _MapPageState createState() => _MapPageState();
}

List<LatLng> eventPositions = [];

class _MapPageState extends State<MapPage> {
  Position? _currentPosition;

  void _getCurrentLocation() async {
    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      _currentPosition = position;
    });
  }

  void _nextPage(BuildContext context, Widget page) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (BuildContext context) => page),
    );
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
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
      body: FutureBuilder<Position>(
        future: Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        ),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final currentPosition = snapshot.data!;
            return FlutterMap(
              options: MapOptions(
                center: LatLng(currentPosition.latitude, currentPosition.longitude),
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
                      point: LatLng(
                        currentPosition.latitude,
                        currentPosition.longitude,
                      ),
                      builder: (ctx) => Container(
                        child: Icon(
                          Icons.location_on,
                          color: Color.fromARGB(255, 13, 123, 248),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
