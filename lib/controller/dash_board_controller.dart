import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:yumprides_driver/constant/constant.dart';
import 'package:yumprides_driver/constant/logdata.dart';
import 'package:yumprides_driver/constant/show_toast_dialog.dart';
import 'package:yumprides_driver/model/driver_location_update.dart';
import 'package:yumprides_driver/model/user_model.dart';
import 'package:yumprides_driver/page/add_bank_details/show_bank_details.dart';
import 'package:yumprides_driver/page/auth_screens/mobile_number_screen.dart';
import 'package:yumprides_driver/page/auth_screens/vehicle_info_screen.dart';
import 'package:yumprides_driver/page/car_service_history/car_service_history_screen.dart';
import 'package:yumprides_driver/page/dash_board.dart';
import 'package:yumprides_driver/page/document_status/document_status_screen.dart';
import 'package:yumprides_driver/page/home_screen/driver_availability_screen.dart';
import 'package:yumprides_driver/page/home_screen/home_screen.dart';
import 'package:yumprides_driver/page/localization_screens/localization_screen.dart';
import 'package:yumprides_driver/page/my_profile/my_profile_screen.dart';
import 'package:yumprides_driver/page/parcel_service/all_parcel_screen.dart';
import 'package:yumprides_driver/page/parcel_service/search_parcel_screen.dart';
import 'package:yumprides_driver/page/privacy_policy/privacy_policy_screen.dart';
import 'package:yumprides_driver/page/terms_of_service/terms_of_service_screen.dart';
import 'package:yumprides_driver/page/wallet/wallet_screen.dart';
import 'package:yumprides_driver/service/api.dart';
import 'package:yumprides_driver/utils/Preferences.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_review/in_app_review.dart';
import 'package:location/location.dart';

import '../page/new_ride_screens/new_ride_screen.dart';

class DashBoardController extends GetxController {
  Location location = Location();
  late StreamSubscription<LocationData> locationSubscription;

  @override
  void onInit() {
    getUsrData();
    locationSubscription = location.onLocationChanged.listen((event) {});
    getCurrentLocation();
    updateToken();
    updateCurrentLocation();
    getPaymentSettingData();

    super.onInit();
  }

  updateToken() async {
    // use the returned token to send messages to users from your custom server
    String? token = await FirebaseMessaging.instance.getToken();

    if (token != null) {
      updateFCMToken(token);
    }
  }

  getCurrentLocation() async {
    LocationData location = await Location().getLocation();
    List<geocoding.Placemark> placeMarks =
        await geocoding.placemarkFromCoordinates(
            location.latitude ?? 0.0, location.longitude ?? 0.0);
    for (var i = 0; i < Constant.allTaxList.length; i++) {
      if (placeMarks.first.country.toString().toUpperCase() ==
          Constant.allTaxList[i].country!.toUpperCase()) {
        Constant.taxList.add(Constant.allTaxList[i]);
      }
    }
    setCurrentLocation(
        location.latitude.toString(), location.longitude.toString());
  }

  getDrawerItem() {
    drawerItems = [
      DrawerItem('Home'.tr, 'assets/icons/ic_home.svg',
      ),
      DrawerItem('All Rides'.tr, 'assets/icons/ic_car.svg',
          section:
          "${"Rides".tr}${(Constant.parcelActive.toString() == "yes" && userModel.value.userData?.parcelDelivery.toString() == "yes") ? " & Parcels:".tr : ":"}"
      ),
      if (Constant.parcelActive.toString() == "yes" &&
          userModel.value.userData?.parcelDelivery.toString() == "yes")
        DrawerItem('Parcel Service'.tr, 'assets/icons/ic_parcel_vehicle.svg'),
      if (Constant.parcelActive.toString() == "yes" &&
          userModel.value.userData?.parcelDelivery.toString() == "yes")
        DrawerItem('All Parcel'.tr, 'assets/icons/ic_all_car.svg'),
      DrawerItem('Documents'.tr, 'assets/icons/ic_car.svg',
          section: 'Vehicle & Service Management:'.tr),
      DrawerItem(
          'Vehicle information'.tr, 'assets/icons/ic_parcel_vehicle.svg'),
      DrawerItem('Car Service History'.tr, 'assets/icons/ic_all_car.svg'),
      DrawerItem('My Profile'.tr, 'assets/icons/ic_profile.svg',
          section: 'Account & Financials:'.tr),
      DrawerItem('My Earnings'.tr, 'assets/icons/ic_wallet.svg'),
      DrawerItem('Add Bank'.tr, 'assets/icons/ic_bank.svg'),
      DrawerItem('Change Language'.tr, 'assets/icons/ic_lang.svg',
          section: 'Settings & Support:'.tr),
      DrawerItem('Terms of Service'.tr, 'assets/icons/ic_terms.svg'),
      DrawerItem('Privacy Policy'.tr, 'assets/icons/ic_privacy.svg'),
      // DrawerItem('Dark Mode'.tr, 'assets/icons/ic_dark.svg', isSwitch: true),
      // SizedBox(height: 0),
      DrawerItem('Rate the App'.tr, 'assets/icons/ic_star_line.svg',
          section: 'Feedback & Support'.tr),
      DrawerItem('Log Out'.tr, 'assets/icons/ic_logout.svg'),
    ];
  }

  getDrawerItemWidget(int pos) {
    if (Constant.parcelActive.toString() == "yes" &&
        userModel.value.userData?.parcelDelivery.toString() == "yes") {
      if(pos == 0){
        Get.to(HomeScreen()/*DriverAvailabilityScreen()*/);
      } else if( pos == 1){
        Get.to(NewRideScreen());
      }
      else if (pos == 2) {
        Get.to(SearchParcelScreen());
      } else if (pos == 3) {
        Get.to(const AllParcelScreen());
      } else if (pos == 4) {
        Get.to(DocumentStatusScreen());
      } else if (pos == 5) {
        Get.to(const VehicleInfoScreen());
      } else if (pos == 6) {
        Get.to(const CarServiceBookHistory());
      } else if (pos == 7) {
        Get.to(MyProfileScreen());
      } else if (pos == 8) {
        Get.to(WalletScreen());
      } else if (pos == 9) {
        Get.to(const ShowBankDetails());
      } else if (pos == 10) {
        Get.to(const LocalizationScreens(intentType: "dashBoard"));
      } else if (pos == 11) {
        Get.to(const TermsOfServiceScreen());
      } else if (pos == 12) {
        Get.to(const PrivacyPolicyScreen());
      }
    } else {
      if(pos == 0){
        Get.to(HomeScreen()/*DriverAvailabilityScreen()*/);
      } else if( pos == 1){
        Get.to(NewRideScreen());
      }
      else if (pos == 2) {
        return Get.to(DocumentStatusScreen());
      } else if (pos == 3) {
        Get.to(const VehicleInfoScreen());
      } else if (pos == 4) {
        Get.to(const CarServiceBookHistory());
      } else if (pos == 5) {
        Get.to(MyProfileScreen());
      } else if (pos == 6) {
        Get.to(WalletScreen());
      } else if (pos == 7) {
        Get.to(const ShowBankDetails());
      } else if (pos == 8) {
        Get.to(const LocalizationScreens(intentType: "dashBoard"));
      } else if (pos == 9) {
        Get.to(const TermsOfServiceScreen());
      } else if (pos == 10) {
        Get.to(const PrivacyPolicyScreen());
      }
    }
  }

  Rx<UserModel> userModel = UserModel().obs;

  getUsrData() async {
    userModel.value = Constant.getUserData();
    try {
      Map<String, String> bodyParams = {
        'phone': userModel.value.userData!.phone.toString(),
        'user_cat': "driver",
        'email': userModel.value.userData!.email.toString(),
        'login_type': userModel.value.userData!.loginType.toString(),
      };
      final response = await http.post(Uri.parse(API.getProfileByPhone),
          headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.getProfileByPhone} ");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBodyPhone = json.decode(response.body);
      if (response.statusCode == 200 &&
          responseBodyPhone['success'] == "success") {
        ShowToastDialog.closeLoader();
        UserModel? value = UserModel.fromJson(responseBodyPhone);
        Preferences.setString(Preferences.user, jsonEncode(value));
        userModel.value = value;
        isActive.value =
            userModel.value.userData!.online == "yes" ? true : false;
      }
    } catch (e) {
      rethrow;
    }
    log("Constant.parcelActive :: ${Constant.parcelActive.toString() == "yes"}  || ${userModel.value.userData?.parcelDelivery.toString() == "yes"}");
    getDrawerItem();
  }

  RxBool isActive = true.obs;
  RxInt selectedDrawerIndex = 0.obs;
  var drawerItems = [];
  final InAppReview inAppReview = InAppReview.instance;


  onSelectItem(int index) async {
    Get.back();
    log("INDEX :: $index");

    if (userModel.value.userData!.parcelDelivery.toString() != "yes" ||
        Constant.parcelActive != "yes") {

      if (index == drawerItems.length - 2) {  // App review button
        try {
          if (await inAppReview.isAvailable()) {
            inAppReview.requestReview();
          } else {
            inAppReview.openStoreListing();
          }
        } catch (e) {
          log("Error triggering in-app review: $e");
        }
      }
      else if (index == drawerItems.length - 1) {  // Log Out button
        Preferences.clearKeyData(Preferences.isLogin);
        Preferences.clearKeyData(Preferences.user);
        Preferences.clearKeyData(Preferences.userId);
        Get.offAll(MobileNumberScreen(isLogin: true));
      }
      else {
        getDrawerItemWidget(index);
      }

    } else {  // Parcel features enabled
      if (index == drawerItems.length - 2) {  // App review button
        try {
          if (await inAppReview.isAvailable()) {
            inAppReview.requestReview();
          } else {
            inAppReview.openStoreListing();
          }
        } catch (e) {
          log("Error triggering in-app review: $e");
        }
      }
      else if (index == drawerItems.length - 1) {  // Log Out button
        Preferences.clearKeyData(Preferences.isLogin);
        Preferences.clearKeyData(Preferences.user);
        Preferences.clearKeyData(Preferences.userId);
        Get.offAll(MobileNumberScreen(isLogin: true));
      }
      else {
        getDrawerItemWidget(index);
      }
    }
  }

  updateCurrentLocation() async {
    if (isActive.value) {
      PermissionStatus permissionStatus = await location.hasPermission();
      if (permissionStatus == PermissionStatus.granted) {
        location.enableBackgroundMode(enable: true);
        location.changeSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter:
                double.parse(Constant.driverLocationUpdateUnit.toString()));
        locationSubscription =
            location.onLocationChanged.listen((locationData) {
          LocationData currentLocation = locationData;
          Constant.currentLocation = locationData;
          DriverLocationUpdate driverLocationUpdate = DriverLocationUpdate(
              rotation: currentLocation.heading.toString(),
              active: isActive.value,
              driverId: Preferences.getInt(Preferences.userId).toString(),
              driverLatitude: currentLocation.latitude.toString(),
              driverLongitude: currentLocation.longitude.toString());
          Constant.driverLocationUpdate
              .doc(Preferences.getInt(Preferences.userId).toString())
              .set(driverLocationUpdate.toJson());
          setCurrentLocation(currentLocation.latitude.toString(),
              currentLocation.longitude.toString());
        });
      } else {
        location.requestPermission().then((permissionStatus) {
          if (permissionStatus == PermissionStatus.granted) {
            location.enableBackgroundMode(enable: true);
            location.changeSettings(
                accuracy: LocationAccuracy.high,
                distanceFilter:
                    double.parse(Constant.driverLocationUpdateUnit.toString()));
            locationSubscription =
                location.onLocationChanged.listen((locationData) {
              LocationData currentLocation = locationData;
              Constant.currentLocation = locationData;
              DriverLocationUpdate driverLocationUpdate = DriverLocationUpdate(
                  rotation: currentLocation.heading.toString(),
                  active: isActive.value,
                  driverId: Preferences.getInt(Preferences.userId).toString(),
                  driverLatitude: currentLocation.latitude.toString(),
                  driverLongitude: currentLocation.longitude.toString());
              Constant.driverLocationUpdate
                  .doc(Preferences.getInt(Preferences.userId).toString())
                  .set(driverLocationUpdate.toJson());
              setCurrentLocation(currentLocation.latitude.toString(),
                  currentLocation.longitude.toString());
            });
          }
        });
      }
    } else {
      DriverLocationUpdate driverLocationUpdate = DriverLocationUpdate(
          rotation: "0",
          active: false,
          driverId: Preferences.getInt(Preferences.userId).toString(),
          driverLatitude: "0",
          driverLongitude: "0");
      Constant.driverLocationUpdate
          .doc(Preferences.getInt(Preferences.userId).toString())
          .set(driverLocationUpdate.toJson());
    }
  }

  // deleteCurrentOrderLocation() {
//   RideData? rideData = Constant.getCurrentRideData();
//   if (rideData != null) {
//     String orderId = "";
//     if (rideData.rideType! == 'driver') {
//       orderId = '${rideData.idUserApp}-${rideData.id}-${rideData.idConducteur}';
//     } else {
//       orderId = (double.parse(rideData.idUserApp.toString()) < double.parse(rideData.idConducteur!))
//           ? '${rideData.idUserApp}-${rideData.id}-${rideData.idConducteur}'
//           : '${rideData.idConducteur}-${rideData.id}-${rideData.idUserApp}';
//     }
//     Location location = Location();
//     location.enableBackgroundMode(enable: false);
//     Constant.locationUpdate.doc(orderId).delete().then((value) async {
//       await updateCurrentLocation(data: rideData);
//       Preferences.clearKeyData(Preferences.currentRideData);
//       locationSubscription.cancel();
//     });
//   }
// }

  Future<dynamic> setCurrentLocation(String latitude, String longitude) async {
    try {
      Map<String, dynamic> bodyParams = {
        'id_user': Preferences.getInt(Preferences.userId),
        'user_cat': userModel.value.userData!.userCat,
        'latitude': latitude,
        'longitude': longitude
      };
      final response = await http.post(Uri.parse(API.updateLocation),
          headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.updateLocation} ");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> updateFCMToken(String token) async {
    try {
      Map<String, dynamic> bodyParams = {
        'user_id': Preferences.getInt(Preferences.userId),
        'fcm_id': token,
        'device_id': "",
        'user_cat': userModel.value.userData!.userCat
      };
      final response = await http.post(Uri.parse(API.updateToken),
          headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.updateToken} ");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200) {
        return responseBody;
      } else {}
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> changeOnlineStatus(bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.changeStatus),
          headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.changeStatus} ");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200) {
        ShowToastDialog.closeLoader();
        updateCurrentLocation();
        return responseBody;
      } else {
        ShowToastDialog.closeLoader();
      }
    } on TimeoutException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<dynamic> getPaymentSettingData() async {
    try {
      final response =
          await http.get(Uri.parse(API.paymentSetting), headers: API.header);
      showLog("API :: URL :: ${API.paymentSetting} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        Preferences.setString(
            Preferences.paymentSetting, jsonEncode(responseBody));
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
      } else {}
    } on TimeoutException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
