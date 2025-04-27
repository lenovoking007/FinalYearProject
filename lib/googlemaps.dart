import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapView extends StatelessWidget {
  GoogleMapView({super.key});

  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(33.4365, 72.0172),
    zoom: 14.0, // Added zoom for better visibility
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map",style:  TextStyle(color: Colors.white),),
centerTitle: true,
      ),
      body: SizedBox.expand(
        child: GoogleMap(
          mapType: MapType.hybrid,
          initialCameraPosition: _initialPosition,
          onMapCreated: (GoogleMapController controller) {
            _controller.complete(controller);
          },
        ),
      ),
    );
  }
}
