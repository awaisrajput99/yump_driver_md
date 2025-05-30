// ignore_for_file: must_be_immutable

import 'package:flutter/services.dart';
import 'package:location/location.dart';
import 'package:yumprides_driver/constant/show_toast_dialog.dart';
import 'package:yumprides_driver/controller/phone_number_controller.dart';
import 'package:yumprides_driver/page/auth_screens/login_screen.dart';
import 'package:yumprides_driver/page/auth_screens/maple_leaf_widget.dart';
import 'package:yumprides_driver/themes/button_them.dart';
import 'package:yumprides_driver/themes/constant_colors.dart';
import 'package:yumprides_driver/themes/responsive.dart';
import 'package:yumprides_driver/utils/theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';
import 'package:yumprides_driver/widget/permission_dialog.dart';

class MobileNumberScreen extends StatefulWidget {
  bool? isLogin;

  MobileNumberScreen({super.key, required this.isLogin});

  @override
  State<MobileNumberScreen> createState() => _MobileNumberScreenState();
}

class _MobileNumberScreenState extends State<MobileNumberScreen> {
  final controller = Get.put(PhoneNumberController());
  reqPermissions() async {
    try {
      PermissionStatus location = await Location().hasPermission();
      if (PermissionStatus.granted != location) {
        showDialogPermission(context);
      }
    } on PlatformException catch (e) {
      ShowToastDialog.showToast("${e.message}");
    }
    await requestTrackingPermission();
  }

  @override
  initState() {
    super.initState();
    reqPermissions();
  }

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 50),
                        Text(
                          widget.isLogin == true
                              ? "Log In with Mobile Number".tr
                              : "Sign Up with Mobile Number".tr,
                          style: TextStyle(
                            fontSize: 24,
                            fontFamily: AppThemeData.semiBold,
                            color: themeChange.getThem()
                                ? AppThemeData.secondary200
                                : AppThemeData.secondary200,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Text(
                          widget.isLogin == true
                              ? "Enter your mobile number to log in securely and get access to your Yum Rides account."
                                  .tr
                              : "Register using your mobile number for a fast and simple Yum Rides sign-up process."
                                  .tr,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: AppThemeData.regular,
                            color: themeChange.getThem()
                                ? AppThemeData.secondary200
                                : AppThemeData.secondary200,
                          ),
                        ),
                        // const SizedBox(height: 60),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: themeChange.getThem()
                        ? AppThemeData.surface50Dark
                        : AppThemeData.surface50,
                    child: Stack(
                      alignment: AlignmentDirectional.bottomCenter,
                      children: [
                        /*Image.asset(
                          themeChange.getThem()
                              ? 'assets/images/ic_bg_signup_dark.png'
                              : 'assets/images/ic_bg_signup_light.png',
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),*/
                        MapleLeafWidget()
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              top: 200,
              left: 20,
              right: 20,
              child: SizedBox(
                height: Responsive.height(80, context),
                width: Responsive.width(85, context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // const SizedBox(height: 10),
                          Container(
                            decoration: BoxDecoration(
                              color: themeChange.getThem()
                                  ? AppThemeData.surface50Dark
                                  : AppThemeData.surface50,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: themeChange.getThem()
                                    ? AppThemeData.grey200Dark
                                    : AppThemeData.grey200,
                              ),
                            ),
                            padding: const EdgeInsets.only(left: 10),
                            child: IntlPhoneField(
                              flagsButtonPadding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              textAlign: TextAlign.start,
                              initialValue: controller.phoneNumber.value,
                              onChanged: (phone) {
                                controller.phoneNumber.value =
                                    phone.completeNumber;
                              },
                              invalidNumberMessage: "number invalid".tr,
                              showDropdownIcon: false,
                              cursorColor: AppThemeData.primary200,
                              disableLengthCheck: true,
                              decoration: InputDecoration(
                                contentPadding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                hintText: 'mobile number'.tr,
                                hintStyle: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppThemeData.regular,
                                    color: themeChange.getThem()
                                        ? ConstantColors.hintTextColor
                                        : ConstantColors.hintTextColor),
                                border: InputBorder.none,
                                isDense: true,
                              ),
                              dropdownTextStyle: TextStyle(
                                fontSize: 16,
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                              ),
                              style: TextStyle(
                                fontSize: 16,
                                fontFamily: AppThemeData.medium,
                                color: themeChange.getThem()
                                    ? AppThemeData.grey900Dark
                                    : AppThemeData.grey900,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text.rich(
                              TextSpan(
                                text: /* widget.isLogin == true
                                    ? "Don't have an account? "
                                    :*/
                                    "Already have an account? ",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontFamily: AppThemeData.regular,
                                  color: themeChange.getThem()
                                      ? AppThemeData.grey800Dark
                                      : AppThemeData.grey800,
                                ),
                                children: [
                                  TextSpan(
                                    text: /*widget.isLogin == true ? "Sign Up" :*/
                                        "Login",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontFamily: AppThemeData.medium,
                                      color: AppThemeData.primary200,
                                      decoration: TextDecoration.underline,
                                      decorationColor: AppThemeData.primary200,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Get.offAll(
                                          () => /*MobileNumberScreen(isLogin: !(widget.isLogin ?? true))*/
                                              LoginScreen(),
                                          duration:
                                              const Duration(milliseconds: 400),
                                          transition: Transition.rightToLeft,
                                        );
                                      },
                                  ),
                                ],
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: ButtonThem.buildButton(
                              context,
                              title: 'Send OTP'.tr,
                              btnHeight: 50,
                              btnColor: AppThemeData.primary200,
                              // txtColor: themeChange.getThem()
                              //     ? AppThemeData.white90
                              //     : AppThemeData.grey80Dark,
                              txtColor: AppThemeData.white90,

                              onPress: () async {
                                try {
                                  FocusScope.of(context).unfocus();
                                  if (controller.phoneNumber.value.isNotEmpty) {
                                    ShowToastDialog.showLoader("Code sending");
                                    controller.sendCode();
                                  }
                                } catch (e) {
                                  print("❌❌ Error while sending OTP");
                                }
                              },
                            ),
                          ),
                          // Align(
                          //   alignment: Alignment.center,
                          //   child: Padding(
                          //     padding: const EdgeInsets.only(top: 30),
                          //     child: Text(
                          //       "or continue with".tr,
                          //       style: TextStyle(
                          //         fontSize: 14,
                          //         color: themeChange.getThem()
                          //             ? AppThemeData.grey400Dark
                          //             : AppThemeData.grey400,
                          //         fontFamily: AppThemeData.regular,
                          //       ),
                          //     ),
                          //   ),
                          // ),
                          // Padding(
                          //     padding: const EdgeInsets.only(top: 30),
                          //     child: ButtonThem.buildBorderButton(
                          //       context,
                          //       title: 'Log in with email address'.tr,
                          //       btnHeight: 50,
                          //       btnColor: themeChange.getThem()
                          //           ? AppThemeData.grey300Dark
                          //           : AppThemeData.grey300,
                          //       txtColor: themeChange.getThem()
                          //           ? AppThemeData.grey900Dark
                          //           : AppThemeData.grey900,
                          //       onPress: () {
                          //         FocusScope.of(context).unfocus();
                          //         Get.back();
                          //       },
                          //       btnBorderColor: themeChange.getThem()
                          //           ? AppThemeData.grey300Dark
                          //           : AppThemeData.grey300,
                          //     )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: isLogin == true
      //     ? Padding(
      //         padding: const EdgeInsets.only(bottom: 20),
      //         child: Text.rich(
      //           textAlign: TextAlign.center,
      //           TextSpan(
      //             text: 'First time in Yum Rides?'.tr,
      //             style: TextStyle(
      //               fontSize: 16,
      //               fontFamily: AppThemeData.regular,
      //               color: themeChange.getThem()
      //                   ? AppThemeData.grey800Dark
      //                   : AppThemeData.grey800,
      //             ),
      //             children: <TextSpan>[
      //               TextSpan(
      //                 text: ' '.tr,
      //                 style: TextStyle(
      //                   fontSize: 16,
      //                   fontFamily: AppThemeData.medium,
      //                   color: AppThemeData.primary200,
      //                 ),
      //               ),
      //               TextSpan(
      //                 recognizer: TapGestureRecognizer()
      //                   ..onTap = () {
      //                     Get.back();
      //                     FocusScope.of(context).unfocus();
      //                     Get.to(MobileNumberScreen(isLogin: false),
      //                         duration: const Duration(
      //                             milliseconds:
      //                                 400), //duration of transitions, default 1 sec
      //                         transition: Transition.rightToLeft);
      //                   }, //transition effect);,
      //                 text: 'Create an account'.tr,
      //                 style: TextStyle(
      //                   fontSize: 16,
      //                   fontFamily: AppThemeData.medium,
      //                   color: AppThemeData.primary200,
      //                   decoration: TextDecoration.underline,
      //                   decorationColor: AppThemeData.primary200,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       )
      //     : Padding(
      //         padding: const EdgeInsets.only(bottom: 20),
      //         child: Text.rich(
      //           textAlign: TextAlign.center,
      //           TextSpan(
      //             text: 'Already book rides?'.tr,
      //             style: TextStyle(
      //               fontSize: 16,
      //               fontFamily: AppThemeData.regular,
      //               color: themeChange.getThem()
      //                   ? AppThemeData.grey800Dark
      //                   : AppThemeData.grey800,
      //             ),
      //             children: <TextSpan>[
      //               TextSpan(
      //                 text: ' '.tr,
      //                 style: TextStyle(
      //                   fontSize: 16,
      //                   fontFamily: AppThemeData.medium,
      //                   color: AppThemeData.primary200,
      //                 ),
      //               ),
      //               TextSpan(
      //                 recognizer: TapGestureRecognizer()
      //                   ..onTap = () {
      //                     Get.back();
      //                   }, //transition effect);,
      //                 text: 'Login'.tr,
      //                 style: TextStyle(
      //                   fontSize: 16,
      //                   fontFamily: AppThemeData.medium,
      //                   color: AppThemeData.primary200,
      //                   decoration: TextDecoration.underline,
      //                   decorationColor: AppThemeData.primary200,
      //                 ),
      //               ),
      //             ],
      //           ),
      //         ),
      //       ),
    );
  }

  showDialogPermission(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LocationPermissionDisclosureDialog(),
    );
  }
}


