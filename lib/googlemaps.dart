import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

class GoogleMapView extends StatefulWidget {
  const GoogleMapView({super.key});

  @override
  State<GoogleMapView> createState() => _GoogleMapViewState();
}

class _GoogleMapViewState extends State<GoogleMapView> {
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(33.4365, 72.0172),
    zoom: 14.0,
  );

  @override
  void initState() {
    super.initState();
    _checkLocationPermissionAndMove();
  }

  Future<void> _checkLocationPermissionAndMove() async {
    var status = await Permission.location.status;
    if (!status.isGranted) {
      status = await Permission.location.request();
      if (!status.isGranted) {
        return;
      }
    }

    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );

    print("Current location: ${position.latitude}, ${position.longitude}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Google Map", style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: GoogleMap(
        mapType: MapType.hybrid,
        initialCameraPosition: _initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }
}
