import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart' as get_cord_address;
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../constant/constant.dart';

class MapScreenController extends GetxController{
  LatLng center = const LatLng(40.7128, -74.0060);
  GoogleMapController? mapController;
  Rx<Location> currentLocation = Location().obs;
  RxMap<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{}.obs;
  final Map<String, Marker> markers = {};
  final TextEditingController currentLocationController =
  TextEditingController();
  TextEditingController departureController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
  }


  getCurrentLocation() async {
    // Check if location service is enabled
    bool serviceEnabled = await currentLocation.value.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await currentLocation.value.requestService();
      if (!serviceEnabled) return; // Handle denial
    }

    // Check permission
    PermissionStatus permission = await currentLocation.value.hasPermission();
    if (permission == PermissionStatus.denied) {
      permission = await currentLocation.value.requestPermission();
      if (permission != PermissionStatus.granted) return;
    }

    try {
      // Get current location
      LocationData location = await currentLocation.value.getLocation();

      // ✅ Update currentLatLng before moving the map
      currentLatLng.value = LatLng(location.latitude!, location.longitude!);

      // ✅ Move map to current location
      moveToCurrentLocation();

      // ✅ Update map camera immediately
      _updateMapCamera(location);

      // ✅ Add marker
      _addCurrentLocationMarker(location);

    } catch (e) {
      print("Error getting location: $e");
    }
  }


  void _updateMapCamera(LocationData location) {
    final currentLatLng = LatLng(location.latitude!, location.longitude!);
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(currentLatLng, 15), // Zoom level 15
    );
  }

  void _addCurrentLocationMarker(LocationData location) {
    final String markerId = "current_location"; // Use a String key
    markers[markerId] = Marker(
      markerId: MarkerId(markerId), // Use MarkerId inside the Marker
      position: LatLng(location.latitude!, location.longitude!),
      infoWindow: const InfoWindow(title: "You are here!"),
    );
    update(); // Notify GetX to refresh UI
  }


  Rx<LatLng?> currentLatLng = Rx<LatLng?>(null);

  void moveToCurrentLocation() {
    if (mapController != null && currentLatLng.value != null) {
      mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLatLng.value!, 16), // Zoom in more
      );
    } else {
      print("MapController or currentLatLng is null.");
    }
  }}