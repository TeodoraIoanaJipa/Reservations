import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsRestaurantLocation extends StatefulWidget {
  final double latitude;
  final double longitude;

  MapsRestaurantLocation({required this.latitude, required this.longitude});

  @override
  State<MapsRestaurantLocation> createState() =>
      MapsRestaurantLocationState(latitude: latitude, longitude: longitude);
}

class MapsRestaurantLocationState extends State<MapsRestaurantLocation> {
  Completer<GoogleMapController> _controller = Completer();
  double latitude;
  double longitude;

  MapsRestaurantLocationState(
      {required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    List<Marker> googleMapsPins = [];

    googleMapsPins.add(Marker(
        markerId: MarkerId('restaurant'),
        draggable: false,
        position: LatLng(latitude, longitude)));

    return new SizedBox(
      height: 350,
      width: 300,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
          target: LatLng(latitude, longitude),
          zoom: 15.0,
        ),
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
        markers: Set.from(googleMapsPins),
      ),
    );
  }
}
