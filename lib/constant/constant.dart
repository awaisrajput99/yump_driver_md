// ignore_for_file: body_might_complete_normally_catch_error

import 'dart:convert';
import 'dart:io';

import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:yumprides_driver/model/parcel_model.dart';
import 'package:yumprides_driver/model/payment_setting_model.dart';
import 'package:yumprides_driver/model/ride_model.dart';
import 'package:yumprides_driver/model/tax_model.dart';
import 'package:yumprides_driver/model/user_model.dart';
import 'package:yumprides_driver/page/chats_screen/conversation_screen.dart';
import 'package:yumprides_driver/themes/constant_colors.dart';
import 'package:yumprides_driver/utils/Preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places_hoc081098/flutter_google_places_hoc081098.dart';
import 'package:flutter_google_places_hoc081098/google_maps_webservice_places.dart';
import 'package:get/get.dart';
// import 'package:google_api_headers/google_api_headers.dart';
import 'package:location/location.dart';
import 'package:map_launcher/map_launcher.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:video_compress/video_compress.dart';
// import 'package:video_thumbnail/video_thumbnail.dart';

import '../utils/theme_provider.dart';
import 'show_toast_dialog.dart';

class Constant {
  static String? kGoogleApiKey = "";
  static String? rideOtp = "yes";
  static String? appVersion = "0.0";
  static String? minimumWalletBalance = "0";
  static String? decimal = "2";
  static String appName = "Yump Rides Driver";
  static String? currency = "\$";
  static bool symbolAtRight = false;
  static List<TaxModel> taxList = [];
  static List<TaxModel> allTaxList = [];

  // static String? taxValue = "0.0";
  // static String? taxType = 'Percentage';
  // static String? taxName = 'Tax';
  static String? distanceUnit = "KM";
  static String? contactUsEmail = "";
  static String agoraId = "8a7e2df835e24a1e9f1864c6b4176617";

  static String? minimumWithdrawalAmount = "0";
  static String? contactUsAddress = "";
  static String? contactUsPhone = "";
  static String? deliveryChargeParcel = "";
  static String? parcelActive = "";
  static String? parcelPerWeightCharge = "";
  static CollectionReference conversation =
      FirebaseFirestore.instance.collection('conversation');

  // static CollectionReference locationUpdate = FirebaseFirestore.instance.collection('ride_location_update');
  static CollectionReference driverLocationUpdate =
      FirebaseFirestore.instance.collection('driver_location_update');
  static LocationData? currentLocation;
  static String liveTrackingMapType = "google";
  static String selectedMapType = 'osm';

  static String driverLocationUpdateUnit = "10";

  static String? jsonNotificationFileURL = "";
  static String? senderId = "maple-rides";
  static String? placeholderUrl = "";

  static PaymentSettingModel getPaymentSetting() {
    final String user = Preferences.getString(Preferences.paymentSetting);
    if (user.isNotEmpty) {
      Map<String, dynamic> userMap = jsonDecode(user);
      return PaymentSettingModel.fromJson(userMap);
    }
    return PaymentSettingModel();
  }

  static String getUuid() {
    var uuid = const Uuid();
    return uuid.v1();
  }

  static UserModel getUserData() {
    final String user = Preferences.getString(Preferences.user);
    Map<String, dynamic> userMap = json.decode(user);
    return UserModel.fromJson(userMap);
  }

/*  static Widget loader(context, {Color? loadingcolor, Color? bgColor}) {
    final themeChange = Provider.of<ThemeProvider>(context);

    return Center(
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: bgColor ??
              (themeChange.getThem()
                  ? AppThemeData.surface50Dark
                  : AppThemeData.surface50),
          borderRadius: BorderRadius.circular(50),
        ),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              loadingcolor ?? AppThemeData.primary200),
          strokeWidth: 3,
        ),
      ),
    );
  }*/

  static Widget emptyView(String msg) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Image.asset('assets/images/empty_placeholde.png'),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 100),
          child: Text(
            msg.tr,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  static Color statusParcelColor(ParcelData data) {
    return data.status == "new"
        ? AppThemeData.primary50
        : data.status == "confirmed"
            ? AppThemeData.info50
            : data.status == "on ride"
                ? AppThemeData.secondary50
                : data.status == "onride"
                    ? AppThemeData.secondary50
                    : data.status == "completed"
                        ? AppThemeData.success50
                        : AppThemeData.error50;
  }

  static Color statusParcelTextColor(ParcelData data) {
    return data.status == "new"
        ? AppThemeData.primary200
        : data.status == "confirmed"
            ? AppThemeData.info300
            : data.status == "on ride"
                ? AppThemeData.secondary200
                : data.status == "onride"
                    ? AppThemeData.secondary200
                    : data.status == "completed"
                        ? AppThemeData.success300
                        : AppThemeData.error200;
  }

  static Color statusColor(RideData data) {
    return data.statut == "new"
        ? AppThemeData.primary50
        : data.statut == "confirmed"
            ? AppThemeData.info50
            : data.statut == "on ride"
                ? AppThemeData.secondary50
                : data.statut == "onride"
                    ? AppThemeData.secondary50
                    : data.statut == "completed"
                        ? AppThemeData.success50
                        : AppThemeData.error50;
  }

  static Color statusTextColor(RideData data) {
    return data.statut == "new"
        ? AppThemeData.primary200
        : data.statut == "confirmed"
            ? AppThemeData.info300
            : data.statut == "on ride"
                ? AppThemeData.secondary200
                : data.statut == "onride"
                    ? AppThemeData.secondary200
                    : data.statut == "completed"
                        ? AppThemeData.success300
                        : AppThemeData.error200;
  }

  String amountShow({required String? amount}) {
    String amountdata =
        (amount == 'null' || amount == '' || amount == null) ? '0' : amount;
    if (Constant.symbolAtRight == true) {
      return "${double.parse(amountdata.toString()).toStringAsFixed(int.parse(Constant.decimal!))}${Constant.currency.toString()}";
    } else {
      return "${Constant.currency.toString()}${double.parse(amountdata.toString()).toStringAsFixed(int.parse(Constant.decimal!))}";
    }
  }

  static Widget loader(context,
      {required bool isDarkMode, Color? loadingcolor, Color? bgColor}) {
    return Center(
      child: Container(
        width: 40,
        height: 40,
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
            color: bgColor ??
                (isDarkMode
                    ? AppThemeData.surface50Dark
                    : AppThemeData.surface50),
            borderRadius: BorderRadius.circular(50)),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              loadingcolor ?? AppThemeData.primary200),
          strokeWidth: 3,
        ),
      ),
    );
  }

  static Future<void> makePhoneCall(String phoneNumber) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: phoneNumber,
    );
    await launchUrl(launchUri);
  }

  static Future<void> launchMapURl(
      String? latitude, String? longLatitude) async {
    String appleUrl =
        'https://maps.apple.com/?saddr=&daddr=$latitude,$longLatitude&directionsmode=driving';
    String googleUrl =
        'https://www.google.com/maps/search/?api=1&query=$latitude,$longLatitude';

    if (Platform.isIOS) {
      if (await canLaunchUrl(Uri.parse(appleUrl))) {
        await canLaunchUrl(Uri.parse(appleUrl));
      }
    } else {
      if (await canLaunchUrl(Uri.parse(googleUrl))) {
        await canLaunchUrl(Uri.parse(googleUrl));
      } else {
        throw 'Could not open the map.';
      }
    }
  }

  static void showShimmerBottomSheet({
    required BuildContext context,
    required String title,
    required int itemCount, // Dynamic shimmer list length
    double? maxHeight, // Optional max height
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        // Calculate dynamic height based on itemCount (Each item ≈ 80px including spacing)
        double calculatedHeight = (itemCount * 80).toDouble();
        double finalHeight = maxHeight != null && calculatedHeight > maxHeight
            ? maxHeight // If calculated height exceeds maxHeight, use maxHeight
            : calculatedHeight;

        return Container(
          height: finalHeight,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              Text(
                title,
                style: TextStyle(fontSize: 20, fontFamily: AppThemeData.bold),
              ),
              SizedBox(height: 10),
              Divider(),
              SizedBox(height: 10),
              // Shimmer Effect List
              Expanded(
                child: ListView.builder(
                  itemCount: itemCount,
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Row(
                        children: [
                          Container(
                            margin: EdgeInsets.only(bottom: 10),
                            height: 70,
                            width: MediaQuery.of(context).size.width * 0.15,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                height: 30,
                                width: MediaQuery.of(context).size.width * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              SizedBox(
                                height: 3,
                              ),
                              Container(
                                margin: EdgeInsets.only(bottom: 10),
                                height: 20,
                                width: MediaQuery.of(context).size.width * 0.5,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Future<Url> uploadChatImageToFireStorage(File image) async {
    ShowToastDialog.showLoader('Uploading image...');
    var uniqueID = const Uuid().v4();
    Reference upload =
        FirebaseStorage.instance.ref().child('images/$uniqueID.png');
    UploadTask uploadTask = upload.putFile(image);

    uploadTask.snapshotEvents.listen((event) {
      ShowToastDialog.showLoader(
          'Uploading image ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /'
          '${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} '
          'KB');
    });
    uploadTask.whenComplete(() {}).catchError((onError) {
      ShowToastDialog.closeLoader();
    });
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();
    ShowToastDialog.closeLoader();
    return Url(
        mime: metaData.contentType ?? 'image', url: downloadUrl.toString());
  }

  static Future<ChatVideoContainer> uploadChatVideoToFireStorage(
      File video) async {
    ShowToastDialog.showLoader('Uploading video');
    var uniqueID = const Uuid().v4();
    Reference upload =
        FirebaseStorage.instance.ref().child('videos/$uniqueID.mp4');

    // Compress the video first.
    File compressedVideo = await _compressVideo(video);
    SettableMetadata metadata = SettableMetadata(contentType: 'video');
    UploadTask uploadTask = upload.putFile(compressedVideo, metadata);

    uploadTask.snapshotEvents.listen((event) {
      ShowToastDialog.showLoader(
          "${"Uploading video".tr} ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} / "
          "${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} KB");
    });

    // Wait for video upload to complete.
    var storageRef = (await uploadTask.whenComplete(() {})).ref;
    var downloadUrl = await storageRef.getDownloadURL();
    var metaData = await storageRef.getMetadata();

    // Instead of using VideoThumbnail.thumbnailFile, generate the thumbnail using video_compress.
    // Using the compressed video file's path (you can adjust quality and position as needed).
    final File thumbnailFile = await VideoCompress.getFileThumbnail(
      compressedVideo.path,
      quality: 50, // adjust quality (0-100)
      position:
          0, // time position (in seconds) from which to capture the thumbnail
    );

    if (thumbnailFile == null) {
      ShowToastDialog.closeLoader();
      throw Exception("Thumbnail generation failed");
    }

    // Upload the generated thumbnail to Firebase Storage.
    String thumbnailDownloadUrl =
        await uploadVideoThumbnailToFireStorage(thumbnailFile);
    ShowToastDialog.closeLoader();

    return ChatVideoContainer(
        videoUrl: Url(
            url: downloadUrl.toString(), mime: metaData.contentType ?? 'video'),
        thumbnailUrl: thumbnailDownloadUrl);
  }

  // static Future<ChatVideoContainer> uploadChatVideoToFireStorage(
  //     File video) async {
  //   ShowToastDialog.showLoader('Uploading video');
  //   var uniqueID = const Uuid().v4();
  //   Reference upload =
  //       FirebaseStorage.instance.ref().child('videos/$uniqueID.mp4');
  //   File compressedVideo = await _compressVideo(video);
  //   SettableMetadata metadata = SettableMetadata(contentType: 'video');
  //   UploadTask uploadTask = upload.putFile(compressedVideo, metadata);
  //   uploadTask.snapshotEvents.listen((event) {
  //     ShowToastDialog.showLoader(
  //         "${"Uploading video".tr} ${(event.bytesTransferred.toDouble() / 1000).toStringAsFixed(2)} /${(event.totalBytes.toDouble() / 1000).toStringAsFixed(2)} KB");
  //   });
  //   var storageRef = (await uploadTask.whenComplete(() {})).ref;
  //   var downloadUrl = await storageRef.getDownloadURL();
  //   var metaData = await storageRef.getMetadata();
  //   final uint8list = await VideoThumbnail.thumbnailFile(
  //       video: downloadUrl,
  //       thumbnailPath: (await getTemporaryDirectory()).path,
  //       imageFormat: ImageFormat.PNG);
  //   final file = File(uint8list ?? '');
  //   String thumbnailDownloadUrl = await uploadVideoThumbnailToFireStorage(file);
  //   ShowToastDialog.closeLoader();
  //   return ChatVideoContainer(
  //       videoUrl: Url(
  //           url: downloadUrl.toString(), mime: metaData.contentType ?? 'video'),
  //       thumbnailUrl: thumbnailDownloadUrl);
  // }

  static Future<File> _compressVideo(File file) async {
    MediaInfo? info = await VideoCompress.compressVideo(file.path,
        quality: VideoQuality.DefaultQuality,
        deleteOrigin: false,
        includeAudio: true,
        frameRate: 24);
    if (info != null) {
      File compressedVideo = File(info.path!);
      return compressedVideo;
    } else {
      return file;
    }
  }

  static Future<String> uploadVideoThumbnailToFireStorage(File file) async {
    var uniqueID = const Uuid().v4();
    Reference upload =
        FirebaseStorage.instance.ref().child('thumbnails/$uniqueID.png');
    UploadTask uploadTask = upload.putFile(file);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  // static Future<void> redirectMap({
  //   required String name,
  //   required double startLatitude,
  //   required double startLongitude,
  //   required double endLatitude,
  //   required double endLongitude,
  // }) async {
  //   // Fetch current location
  //   geolocator.Position currentPosition =
  //       await geolocator.Geolocator.getCurrentPosition(
  //     // ignore: deprecated_member_use
  //     desiredAccuracy: geolocator.LocationAccuracy.high,
  //   );

  //   // Coordinates for current location, starting point, and ending point
  //   Coords currentLocation =
  //       Coords(currentPosition.latitude, currentPosition.longitude);
  //   Coords startPoint = Coords(startLatitude, startLongitude);
  //   Coords endPoint = Coords(endLatitude, endLongitude);

  //   // Open the map and draw the route
  //   if (Constant.liveTrackingMapType == "google") {
  //     bool? isAvailable = await MapLauncher.isMapAvailable(MapType.google);
  //     if (isAvailable == true) {
  //       await MapLauncher.showDirections(
  //         mapType: MapType.google,
  //         directionsMode: DirectionsMode.driving,
  //         origin: currentLocation, // Current location
  //         destination: startPoint, // Starting point
  //       );
  //       await MapLauncher.showDirections(
  //         mapType: MapType.google,
  //         directionsMode: DirectionsMode.driving,
  //         origin: startPoint, // Starting point
  //         destination: endPoint, // Ending point
  //       );
  //     } else {
  //       // Fallback to Apple Maps if Google Maps is not available
  //       await MapLauncher.showDirections(
  //         mapType: MapType.apple,
  //         directionsMode: DirectionsMode.driving,
  //         origin: currentLocation,
  //         destination: startPoint,
  //       );
  //       await MapLauncher.showDirections(
  //         mapType: MapType.apple,
  //         directionsMode: DirectionsMode.driving,
  //         origin: startPoint,
  //         destination: endPoint,
  //       );
  //     }
  //   } else if (Constant.liveTrackingMapType == "waze") {
  //     bool? isAvailable = await MapLauncher.isMapAvailable(MapType.waze);
  //     if (isAvailable == true) {
  //       await MapLauncher.showDirections(
  //         mapType: MapType.waze,
  //         directionsMode: DirectionsMode.driving,
  //         origin: currentLocation,
  //         destination: startPoint,
  //       );
  //       await MapLauncher.showDirections(
  //         mapType: MapType.waze,
  //         directionsMode: DirectionsMode.driving,
  //         origin: startPoint,
  //         destination: endPoint,
  //       );
  //     } else {
  //       ShowToastDialog.showToast("Waze is not installed");
  //     }
  //   }
  //   // Add other map types (e.g., yandexNavi, yandexMaps, etc.) similarly
  // }

  static Future<void> redirectMap({
    required String name,
    required double startLatitude,
    required double startLongitude,
    required double endLatitude,
    required double endLongitude,
  }) async {
    // Fetch current location
    geolocator.Position currentPosition =
        await geolocator.Geolocator.getCurrentPosition(
      desiredAccuracy: geolocator.LocationAccuracy.high,
    );

    // Coordinates for current location, starting point, and ending point
    Coords currentLocation =
        Coords(currentPosition.latitude, currentPosition.longitude);
    Coords startPoint = Coords(startLatitude, startLongitude);
    Coords endPoint = Coords(endLatitude, endLongitude);

    // Convert Coords to Waypoint for waypoints (used in Google Maps)
    Waypoint startWaypoint = Waypoint(
      startPoint.latitude, // Coords object for the starting point
      startPoint.longitude, // Coords object for the starting point
      "Start Point", // Optional: Name for the waypoint
    );

    // Open the map and show directions
    if (Constant.liveTrackingMapType == "google") {
      bool? isAvailable = await MapLauncher.isMapAvailable(MapType.google);
      if (isAvailable == true) {
        // Use waypoints if supported (Google Maps)
        await MapLauncher.showDirections(
          mapType: MapType.google,
          directionsMode: DirectionsMode.driving,
          origin: currentLocation, // Current location
          destination: endPoint, // End point
          waypoints: [startWaypoint], // Start point as a waypoint
        );
      } else {
        // Fallback to Apple Maps if Google Maps is not available
        await _showDirectionsInTwoSteps(
          mapType: MapType.apple,
          currentLocation: currentLocation,
          startPoint: startPoint,
          endPoint: endPoint,
        );
      }
    } else if (Constant.liveTrackingMapType == "waze") {
      bool? isAvailable = await MapLauncher.isMapAvailable(MapType.waze);
      if (isAvailable == true) {
        // Waze does not support waypoints, so show directions in two steps
        await _showDirectionsInTwoSteps(
          mapType: MapType.waze,
          currentLocation: currentLocation,
          startPoint: startPoint,
          endPoint: endPoint,
        );
      } else {
        ShowToastDialog.showToast("Waze is not installed");
      }
    }
    // Add other map types (e.g., yandexNavi, yandexMaps, etc.) similarly
  }

  static Future<void> _showDirectionsInTwoSteps({
    required MapType mapType,
    required Coords currentLocation,
    required Coords startPoint,
    required Coords endPoint,
  }) async {
    // Step 1: Current Location → Start Point
    await MapLauncher.showDirections(
      mapType: mapType,
      directionsMode: DirectionsMode.driving,
      origin: currentLocation,
      destination: startPoint,
    );

    // Step 2: Start Point → End Point
    await MapLauncher.showDirections(
      mapType: mapType,
      directionsMode: DirectionsMode.driving,
      origin: startPoint,
      destination: endPoint,
    );
  }

  static redirectMap2(
      {required String name,
      required double latitude,
      required double longLatitude}) async {
    if (Constant.liveTrackingMapType == "google") {
      bool? isAvailable = await MapLauncher.isMapAvailable(MapType.google);
      if (isAvailable == true) {
        await MapLauncher.showDirections(
          mapType: MapType.google,
          directionsMode: DirectionsMode.driving,
          destinationTitle: name,
          destination: Coords(latitude, longLatitude),
        );
      } else {
        // ShowToastDialog.showToast("Google map is not installed");
        await MapLauncher.showDirections(
          mapType: MapType.apple,
          directionsMode: DirectionsMode.driving,
          destinationTitle: name,
          destination: Coords(latitude, longLatitude),
        );
      }
    } else if (Constant.liveTrackingMapType == "googleGo") {
      bool? isAvailable = await MapLauncher.isMapAvailable(MapType.googleGo);
      if (isAvailable == true) {
        await MapLauncher.showDirections(
          mapType: MapType.googleGo,
          directionsMode: DirectionsMode.driving,
          destinationTitle: name,
          destination: Coords(latitude, longLatitude),
        );
      } else {
        ShowToastDialog.showToast("Google Go map is not installed");
      }
    } else if (Constant.liveTrackingMapType == "waze") {
      bool? isAvailable = await MapLauncher.isMapAvailable(MapType.waze);
      if (isAvailable == true) {
        await MapLauncher.showDirections(
          mapType: MapType.waze,
          directionsMode: DirectionsMode.driving,
          destinationTitle: name,
          destination: Coords(latitude, longLatitude),
        );
      } else {
        ShowToastDialog.showToast("Waze is not installed");
      }
    } else if (Constant.liveTrackingMapType == "mapswithme") {
      bool? isAvailable = await MapLauncher.isMapAvailable(MapType.mapswithme);
      if (isAvailable == true) {
        await MapLauncher.showDirections(
          mapType: MapType.mapswithme,
          directionsMode: DirectionsMode.driving,
          destinationTitle: name,
          destination: Coords(latitude, longLatitude),
        );
      } else {
        ShowToastDialog.showToast("Mapswithme is not installed");
      }
    } else if (Constant.liveTrackingMapType == "yandexNavi") {
      bool? isAvailable = await MapLauncher.isMapAvailable(MapType.yandexNavi);
      if (isAvailable == true) {
        await MapLauncher.showDirections(
          mapType: MapType.yandexNavi,
          directionsMode: DirectionsMode.driving,
          destinationTitle: name,
          destination: Coords(latitude, longLatitude),
        );
      } else {
        ShowToastDialog.showToast("YandexNavi is not installed");
      }
    } else if (Constant.liveTrackingMapType == "yandexMaps") {
      bool? isAvailable = await MapLauncher.isMapAvailable(MapType.yandexMaps);
      if (isAvailable == true) {
        await MapLauncher.showDirections(
          mapType: MapType.yandexMaps,
          directionsMode: DirectionsMode.driving,
          destinationTitle: name,
          destination: Coords(latitude, longLatitude),
        );
      } else {
        ShowToastDialog.showToast("yandexMaps map is not installed");
      }
    }
  }

  Future<PlacesDetailsResponse?> handlePressButton(BuildContext context) async {
    void onError(response) {
      ShowToastDialog.showToast(response.errorMessage ?? 'Unknown error');
    }

    // show input autocomplete with selected mode
    // then get the Prediction selected
    final p = await PlacesAutocomplete.show(
        context: context,
        apiKey: Constant.kGoogleApiKey,
        onError: onError,
        mode: Mode.overlay,
        language: 'fr',
        components: [],
        resultTextStyle: Theme.of(context).textTheme.titleMedium);

    if (p == null) {
      return null;
    }

    // get detail (lat/lng)
    final places = GoogleMapsPlaces(
      apiKey: Constant.kGoogleApiKey,
      // apiHeaders: await const GoogleApiHeaders().getHeaders(),
      apiHeaders: await _createGoogleHeaders(),
    );

    final detail = await places.getDetailsByPlaceId(p.placeId!);

    return detail;
  }

  Future<Map<String, String>> _createGoogleHeaders() async {
    return {
      'X-Android-Package': 'com.yump.driver',
      'X-Android-Cert':
          'EA:AD:55:A5:2C:87:A4:A3:9E:62:DA:63:8F:E5:A2:0A:F5:60:0C:44', // Replace with your SHA1
    };
  }

  String capitalizeWords(String input) {
    if (input.isEmpty) return input;
    if (input == 'onride') {
      return 'On Ride';
    } else if (input == 'driver_rejected') {
      return 'Driver Rejected';
    } else {
      List<String> words = input.split(' ');
      List<String> capitalizedWords = words.map((word) {
        if (word.isEmpty) return word;
        return word[0].toUpperCase() + word.substring(1).toLowerCase();
      }).toList();
      return capitalizedWords.join(' ').replaceAll('_', ' ');
    }
  }
}

class Url {
  String mime;

  String url;

  String? videoThumbnail;

  Url({this.mime = '', this.url = '', this.videoThumbnail});

  factory Url.fromJson(Map<dynamic, dynamic> parsedJson) {
    return Url(
        mime: parsedJson['mime'] ?? '',
        url: parsedJson['url'] ?? '',
        videoThumbnail: parsedJson['videoThumbnail'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'mime': mime, 'url': url, 'videoThumbnail': videoThumbnail};
  }
}
