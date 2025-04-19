import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:yumprides_driver/constant/show_toast_dialog.dart';

import '../utils/Preferences.dart';

class MapScreenController extends GetxController{
  LatLng center = const LatLng(40.7128, -74.0060);
  GoogleMapController? mapController;
  Rx<Location> currentLocation = Location().obs;
  RxMap<PolylineId, Polyline> polyLines = <PolylineId, Polyline>{}.obs;
  final Map<String, Marker> markers = {};
  RxBool isAccepting = false.obs;
  RxBool isRejecting = false.obs;
  final TextEditingController currentLocationController =
  TextEditingController();
  TextEditingController departureController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    getCurrentLocation();
    print("current location:=========${Preferences.getString(Preferences.accesstoken)}");
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

  void _addCurrentLocationMarker(LocationData location) async {
    final String markerId = "current_location";
    final BitmapDescriptor customIcon = await _getLollipopMarkerIcon();

    markers[markerId] = Marker(
      markerId: MarkerId(markerId),
      position: LatLng(location.latitude!, location.longitude!),
      infoWindow: const InfoWindow(title: "You are here!"),
      icon: customIcon,
    );
    update(); // Notify GetX to refresh UI
  }


  Future<BitmapDescriptor> _getLollipopMarkerIcon() async {
    return await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/ic_lollipop.png',
    );
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
  }

  Future<Map<String, dynamic>> available({
    required String driverId,
    required String sessionId,
  }) async {
    const String url = "https://yumprides.ca/admin/api/ride/accept";

    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    final Map<String, String> body = {
      "driver_id": driverId,
      "session_id": sessionId,
    };

    try {
      isAccepting.value = true;
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      debugPrint('API: https://yumprides.ca/admin/api/ride/accept');
      debugPrint('request: $body');
      debugPrint("Response status code: ${response.statusCode}");
      debugPrint("Response: ${response.body}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        isAccepting.value = false;
        return responseData;

      } else {
        isAccepting.value = false;

        return {
          "success": false,
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      isAccepting.value = false;

      return {
        "success": false,
        "message": "Something went wrong: $e"
      };
    }
  }



  Future<Map<String, dynamic>> busy({
    required String driverId,
    required String sessionId,
  }) async {
    const String url = "https://yumprides.ca/admin/api/ride/reject";

    final Map<String, String> headers = {
      "Content-Type": "application/json",
    };

    final Map<String, String> body = {
      "driver_id": driverId,
      "session_id": sessionId,
    };

    try {
      isRejecting.value = true;
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body),
      );
      debugPrint('API: https://yumprides.ca/admin/api/ride/reject');
      debugPrint('request: $body');
      debugPrint("Response status code: ${response.statusCode}");
      debugPrint("Response: ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        isRejecting.value = false;
        return responseData;
      } else {
        isRejecting.value = false;
        return {
          "success": "Failed",
          "message": "Server error: ${response.statusCode}"
        };
      }
    } catch (e) {
      isRejecting.value = false;
      return {
        "success": "Failed",
        "message": "Something went wrong: $e"
      };
    }
  }

}