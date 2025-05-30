import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:yumprides_driver/constant/logdata.dart';
import 'package:yumprides_driver/constant/show_toast_dialog.dart';
import 'package:yumprides_driver/model/user_model.dart';
import 'package:yumprides_driver/page/auth_screens/otp_screen.dart';
import 'package:yumprides_driver/service/api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../constant/custom_toast.dart';
import '../exceptions/otp_sending_failed.dart';

class PhoneNumberController extends GetxController {
  RxString phoneNumber = ''.obs;

  sendCode() async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber.value,
        verificationCompleted: (PhoneAuthCredential credential) {},
        verificationFailed: (FirebaseAuthException e) {
          final failure = OtpSendingFailure.code(e.code);
          ShowToastDialog.closeLoader();
          print("Phone number sent to Firebase: ${phoneNumber.value}");
          print("❌ Error code: ${e.code}");
          print("❌ Error message: ${e.message}");
          print("❌ Mapped failure message: ${failure.message}");

          CustomToast.showErrorToast(failure.message);

          if (e.code == 'invalid-phone-number') {
            ShowToastDialog.showToast(
                "The provided phone number is not valid.");
          } else {
            print(e.message.toString());
            ShowToastDialog.showToast(e.message.toString() + e.code);
          }
          
        },
        codeSent: (String verificationId, int? resendToken) {
          print("Code sent!!!!");
          ShowToastDialog.closeLoader();
          Get.to(OtpScreen(
            phoneNumber: phoneNumber.value,
            verificationId: verificationId,
          ));
        },
        codeAutoRetrievalTimeout: (String verificationId) {},
      );
    } catch (e) {
      print("This is the error while sending OTP $e");
    }
  }

  Future<bool?> phoneNumberIsExit(Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.getExistingUserOrNot),
          headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.getExistingUserOrNot} ");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        if (responseBody['data'] == true) {
          return true;
        } else {
          return false;
        }
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
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }

  Future<UserModel?> getDataByPhoneNumber(
      Map<String, String> bodyParams) async {
    try {
      ShowToastDialog.showLoader("Please wait");
      final response = await http.post(Uri.parse(API.getProfileByPhone),
          headers: API.header, body: jsonEncode(bodyParams));
      showLog("API :: URL :: ${API.getProfileByPhone} ");
      showLog("API :: Request Body :: ${jsonEncode(bodyParams)} ");
      showLog("API :: Request Header :: ${API.header.toString()} ");
      showLog("API :: responseStatus :: ${response.statusCode} ");
      showLog("API :: responseBody :: ${response.body} ");
      Map<String, dynamic> responseBody = json.decode(response.body);
      if (response.statusCode == 200 && responseBody['success'] == "success") {
        ShowToastDialog.closeLoader();
        return UserModel.fromJson(responseBody);
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
    } catch (e) {
      ShowToastDialog.closeLoader();
      ShowToastDialog.showToast(e.toString());
    }
    return null;
  }
}
