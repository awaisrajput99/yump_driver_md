import 'dart:io';

import 'package:yumprides_driver/constant/show_toast_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';

import 'package:location/location.dart';

class LocationPermissionDisclosureDialog extends StatelessWidget {
  const LocationPermissionDisclosureDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Location Access Disclosure'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'We need access to your location to assign for booking feature.',
            ),
            SizedBox(height: 10),
            Text(
              'This information will only be used for booking purpose and will not be shared with any third parties.',
            ),
          ],
        ),
      ),
      actions: <Widget>[
        MaterialButton(
          onPressed: () {
            _requestLocationPermission();
          },
          child: const Text(
            'Continue',
            style: TextStyle(color: Colors.green),
          ),
        ),
        // MaterialButton(
        //   onPressed: () {
        //     if (Platform.isAndroid) {
        //       // For Android, close the app
        //       SystemNavigator.pop();
        //     } else if (Platform.isIOS) {
        //       // For iOS, pop the navigation stack until the first screen
        //       Navigator.of(context).popUntil((route) => route.isFirst);
        //     }
        //   },
        //   child: const Text('Decline', style: TextStyle(color: Colors.red)),
        // ),
      ],
    );
  }

  // Method to request location permission using permission_handler package
  void _requestLocationPermission() async {
    PermissionStatus location = await Location().requestPermission();
    if (location == PermissionStatus.granted) {
      Get.back();
    } else {
      Get.back();
      ShowToastDialog.showToast(
          "Location access denied. Please enable it in settings to continue.");
    }
  }
}

Future<void> requestTrackingPermission() async {
  // Ensure the framework is initialized
  final trackingStatus =
      await AppTrackingTransparency.trackingAuthorizationStatus;

  if (trackingStatus == TrackingStatus.notDetermined) {
    // Show the ATT prompt
    final status = await AppTrackingTransparency.requestTrackingAuthorization();
    print("Tracking permission status: $status");
  } else {
    print("Tracking already authorized or denied: $trackingStatus");
  }
}
