import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as gmaps;
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_google_places_sdk/flutter_google_places_sdk.dart';

class GoogleMapsPage extends StatefulWidget {
  const GoogleMapsPage({Key? key}) : super(key: key);

  @override
  _GoogleMapsPageState createState() => _GoogleMapsPageState();
}

class _GoogleMapsPageState extends State<GoogleMapsPage> {
  final Completer<gmaps.GoogleMapController> _controller = Completer();

  static const gmaps.CameraPosition _initialCameraPosition = gmaps.CameraPosition(
    target: gmaps.LatLng(33.6844, 73.0479),
    zoom: 10,
  );

  final TextEditingController _searchController = TextEditingController();
  gmaps.Marker? _searchedMarker;
  gmaps.Marker? _currentLocationMarker;
  Position? _currentPosition;

  bool _loadingLocation = false;

  // Use your actual Google API key here
  final FlutterGooglePlacesSdk _places =
  FlutterGooglePlacesSdk('AIzaSyA2FMwGGp3W0pn60cTkNKIxqBKFj2K817Y');

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() {
      _loadingLocation = true;
    });

    final status = await Permission.location.request();

    if (status.isGranted) {
      try {
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );

        setState(() {
          _currentPosition = position;
          _currentLocationMarker = gmaps.Marker(
            markerId: const gmaps.MarkerId('current_location'),
            position: gmaps.LatLng(position.latitude, position.longitude),
            icon: gmaps.BitmapDescriptor.defaultMarkerWithHue(
                gmaps.BitmapDescriptor.hueAzure),
            infoWindow: const gmaps.InfoWindow(title: 'Your Location'),
          );
        });

        final gmaps.GoogleMapController controller = await _controller.future;
        controller.animateCamera(gmaps.CameraUpdate.newLatLngZoom(
          gmaps.LatLng(position.latitude, position.longitude),
          15,
        ));
      } catch (e) {
        debugPrint('Error getting location: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error getting location: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location permission denied.')),
      );
    }

    setState(() {
      _loadingLocation = false;
    });
  }

  Future<void> _searchLocation(String query) async {
    if (query.isEmpty) return;

    try {
      final result = await _places.findAutocompletePredictions(query);

      if (result.predictions.isNotEmpty) {
        final placeId = result.predictions.first.placeId;

        final placeDetails = await _places.fetchPlace(
          placeId,
          fields: [PlaceField.Location],
        );

        final latLng = placeDetails.place?.latLng;

        if (latLng != null) {
          setState(() {
            _searchedMarker = gmaps.Marker(
              markerId: const gmaps.MarkerId('searched_location'),
              position: gmaps.LatLng(latLng.lat, latLng.lng),
              infoWindow: gmaps.InfoWindow(title: query),
            );
          });

          final gmaps.GoogleMapController controller = await _controller.future;
          controller.animateCamera(gmaps.CameraUpdate.newLatLngZoom(
            gmaps.LatLng(latLng.lat, latLng.lng),
            15,
          ));
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location details not found.')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location not found.')),
        );
      }
    } catch (e, stacktrace) {
      debugPrint('Error searching location: $e');
      debugPrint(stacktrace.toString());

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error searching location: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Maps', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF0066CC),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Stack(
        children: [
          gmaps.GoogleMap(
            mapType: gmaps.MapType.normal,
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            initialCameraPosition: _initialCameraPosition,
            onMapCreated: (gmaps.GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: {
              if (_currentLocationMarker != null) _currentLocationMarker!,
              if (_searchedMarker != null) _searchedMarker!,
            },
          ),
          Positioned(
            top: 15,
            left: 15,
            right: 15,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Search location...',
                  border: InputBorder.none,
                  icon: Icon(Icons.search, color: Color(0xFF0066CC)),
                ),
                onSubmitted: _searchLocation,
              ),
            ),
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF0066CC),
              child: _loadingLocation
                  ? const SpinKitCircle(color: Colors.white, size: 24)
                  : const Icon(Icons.my_location, color: Colors.white),
              onPressed: _loadingLocation ? null : _getCurrentLocation,
            ),
          ),
        ],
      ),
    );
  }
}
