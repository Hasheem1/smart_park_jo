import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapPickerScreen extends StatefulWidget {
  final LatLng? initialLocation;
  final String? initialPlaceName;

  const MapPickerScreen({super.key, this.initialLocation, this.initialPlaceName});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  LatLng? pickedLocation;
  LatLng? currentLocation;
  GoogleMapController? _controller;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    pickedLocation = widget.initialLocation;
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showError('Location services are disabled.');
        setState(() => loading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _showError('Location permission denied.');
        setState(() => loading = false);
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      setState(() {
        currentLocation = LatLng(position.latitude, position.longitude);
        if (pickedLocation == null) pickedLocation = currentLocation;
        loading = false;
      });

      if (widget.initialPlaceName != null && widget.initialPlaceName!.isNotEmpty) {
        await _movePinToAddress(widget.initialPlaceName!);
      }
    } catch (e) {
      _showError('Failed to get location: $e');
      setState(() => loading = false);
    }
  }

  Future<void> _movePinToAddress(String placeName) async {
    try {
      List<Location> locations = await locationFromAddress(placeName);
      if (locations.isNotEmpty) {
        LatLng target = LatLng(locations[0].latitude, locations[0].longitude);
        setState(() => pickedLocation = target);
        _controller?.animateCamera(CameraUpdate.newLatLngZoom(target, 16));
      }
    } catch (e) {
      print("Address lookup failed: $e");
    }
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
          body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Pick Location")),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
                target: pickedLocation ?? currentLocation!, zoom: 16),
            onMapCreated: (controller) => _controller = controller,
            myLocationEnabled: true,
            onTap: (pos) => setState(() => pickedLocation = pos),
            markers: pickedLocation != null
                ? {Marker(markerId: const MarkerId("picked"), position: pickedLocation!)}
                : {},
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton.icon(
              onPressed: () {
                if (pickedLocation != null) Navigator.pop(context, pickedLocation);
              },
              icon: const Icon(Icons.check),
              label: const Text("Confirm Location"),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          )
        ],
      ),
    );
  }
}
