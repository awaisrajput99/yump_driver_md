import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:yumprides_driver/constant/constant.dart';
import 'package:yumprides_driver/constant/logdata.dart';
import 'package:yumprides_driver/constant/show_toast_dialog.dart';
import 'package:yumprides_driver/model/parcel_model.dart';
import 'package:yumprides_driver/model/user_model.dart';
import 'package:yumprides_driver/service/api.dart';
import 'package:yumprides_driver/utils/Preferences.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';

class ParcelOrderController extends GetxController {
  Timer? timer;
  var isLoading = true.obs;
  @override
  void onInit() {
    getUsrData();
    getParcel(isInit: true);
    timer = Timer.periodic(const Duration(seconds: 20), (timer) {
      getParcel();
    });
    super.onInit();
  }

  @override
  void onClose() {
    timer?.cancel();
    super.onClose();
  }

  Rx<UserModel> userModel = UserModel().obs;
  getUsrData() async {
    userModel.value = Constant.getUserData();
  }

  var parcelList = <ParcelData>[].obs;
  Future<dynamic> getParcel({bool isInit = false}) async {
    try {
      if (isInit) {
        ShowToastDialog.showLoader("Please wait");
      }
      final response = await http.get(
          Uri.parse(
              "${API.getDriverParcel}?id_driver=${Preferences.getInt(Preferences.userId)}"),
          headers: API.header);
      showLog(
          "API :: URL :: ${API.getDriverParcel}?id_driver=${Preferences.getInt(Preferences.userId)}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        isLoading.value = false;
        ParcelModel model = ParcelModel.fromJson(responseBody);
        parcelList.value = model.data!;
        ShowToastDialog.closeLoader();
      } else {
        parcelList.clear();
        ShowToastDialog.closeLoader();
        isLoading.value = false;
      }
    } on TimeoutException catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on SocketException catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.message.toString());
    } on Error catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    } catch (e) {
      isLoading.value = false;
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Rx<TextEditingController> resonController = TextEditingController().obs;
  Rx<TextEditingController> otpController = TextEditingController().obs;

  Future<dynamic> cancelParcel(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.parcelRejected),
          headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.parcelRejected}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> completeParcel(
    Map<String, String> bodyParams,
  ) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.parcelComplete),
          headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.parcelComplete}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }

  Future<dynamic> verifyOTP(
      {required String userId, required String rideId}) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.get(
          Uri.parse(
              "${API.rideOtpVerify}?id_user_app=$userId&otp=${otpController.value.text.toString()}&ride_id=$rideId&ride_type=parcel"),
          headers: API.header);
      showLog(
          "API :: URL :: ${API.rideOtpVerify}?id_user_app=$userId&otp=${otpController.value.text.toString()}&ride_id=$rideId&ride_type=parcel}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        await http.get(
            Uri.parse(
                "${API.reGenerateOtp}?id_user_app=$userId&ride_id=$rideId"),
            headers: API.header);

        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error'].toString());
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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

  Future<dynamic> onRideParcel(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.parcelOnride),
          headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.parcelOnride}");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)}");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);

      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return responseBody;
      } else if (response.statusCode == 200 &&
          responseBody['success'] == "Failed") {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(responseBody['error']);
      } else {
        ShowToastDialog.closeLoader();
        ShowToastDialog.showToast(
            'Something want wrong. Please try again later');
        throw Exception('Failed to load album');
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
    }
    ShowToastDialog.closeLoader();
    return null;
  }
}
