// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:yumprides_driver/constant/show_toast_dialog.dart';
import 'package:yumprides_driver/controller/sign_up_controller.dart';
import 'package:yumprides_driver/page/auth_screens/login_screen.dart';
import 'package:yumprides_driver/themes/button_them.dart';
import 'package:yumprides_driver/themes/constant_colors.dart';
import 'package:yumprides_driver/themes/responsive.dart';
import 'package:yumprides_driver/themes/text_field_them.dart';
import 'package:yumprides_driver/utils/Preferences.dart';
import 'package:yumprides_driver/utils/dark_theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:provider/provider.dart';

class SignupScreen extends StatelessWidget {
  SignupScreen({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();

    return GetX<SignUpController>(
        init: SignUpController(),
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: AppThemeData.primary200,
            body: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Container(
                          // color: AppThemeData.primary200,
                          color: Colors.white,

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const SizedBox(height: 20),
                                    Text(
                                      "Create Your Account".tr,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontFamily: AppThemeData.semiBold,
                                        color: isDarkMode
                                            ? AppThemeData.secondary200
                                            : AppThemeData.secondary200,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "Sign up for a personalized Yum Rides experience. Start booking your rides in just a few taps."
                                          .tr,
                                      textAlign: TextAlign.start,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontFamily: AppThemeData.regular,
                                        color: isDarkMode
                                            ? AppThemeData.secondary200
                                            : AppThemeData.secondary200,
                                      ),
                                    ),
                                    // const SizedBox(height: 60),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        // flex: 4,
                        child: Container(
                          color: isDarkMode
                              ? AppThemeData.surface50Dark
                              : AppThemeData.surface50,
                          child: Stack(
                            alignment: AlignmentDirectional.bottomCenter,
                            children: [
                              Image.asset(
                                isDarkMode
                                    ? 'assets/images/ic_bg_signup_dark.png'
                                    : 'assets/images/ic_bg_signup_light.png',
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 140,
                    left: 20,
                    right: 20,
                    child: SizedBox(
                      height: Responsive.height(80, context),
                      width: Responsive.width(85, context),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: TextFieldWidget(
                                          prefix: IconButton(
                                            onPressed: () {},
                                            icon: SvgPicture.asset(
                                              'assets/icons/ic_user.svg',
                                              colorFilter: ColorFilter.mode(
                                                themeChange.getThem()
                                                    ? AppThemeData.grey500Dark
                                                    : AppThemeData.grey500,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                          hintText: 'Name'.tr,
                                          controller: controller
                                              .firstNameController.value,
                                          textInputType: TextInputType.text,
                                          maxLength: 22,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 16),
                                          validators: (String? value) {
                                            if (value!.isNotEmpty) {
                                              return null;
                                            } else {
                                              return 'required'.tr;
                                            }
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: TextFieldWidget(
                                          prefix: IconButton(
                                            onPressed: () {},
                                            icon: SvgPicture.asset(
                                              'assets/icons/ic_user.svg',
                                              colorFilter: ColorFilter.mode(
                                                themeChange.getThem()
                                                    ? AppThemeData.grey500Dark
                                                    : AppThemeData.grey500,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                          hintText: 'Last Name'.tr,
                                          controller: controller
                                              .lastNameController.value,
                                          textInputType: TextInputType.text,
                                          maxLength: 22,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 16),
                                          validators: (String? value) {
                                            if (value!.isNotEmpty) {
                                              return null;
                                            } else {
                                              return 'required'.tr;
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey200Dark
                                                : AppThemeData.grey200,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(0))),
                                      padding: const EdgeInsets.only(left: 10),
                                      child: IntlPhoneField(
                                        textAlign: TextAlign.start,
                                        flagsButtonPadding:
                                            const EdgeInsets.symmetric(
                                                horizontal: 8),
                                        initialValue:
                                            controller.phoneNumber.value.text,
                                        onChanged: (number) {
                                          controller.phoneNumber.value.text =
                                              number.completeNumber;
                                        },
                                        showDropdownIcon: false,
                                        readOnly: controller.loginType.value ==
                                                    "google" ||
                                                controller.loginType.value ==
                                                    "apple"
                                            ? false
                                            : true,
                                        invalidNumberMessage:
                                            "number invalid".tr,
                                        disableLengthCheck: true,
                                        decoration: InputDecoration(
                                          hintStyle: TextStyle(
                                            fontSize: 16,
                                            color: themeChange.getThem()
                                                ? AppThemeData.grey400Dark
                                                : AppThemeData.grey400,
                                            fontFamily: AppThemeData.regular,
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 16),
                                          hintText: 'mobile number'.tr,
                                          border: InputBorder.none,
                                          isDense: true,
                                        ),
                                      )),

                                  // TextFieldWidget(
                                  //   hintText: 'phone'.tr,
                                  //   controller: _phoneController,
                                  //   textInputType: TextInputType.number,
                                  //   maxLength: 13,
                                  //   enabled: false,
                                  //  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                                  //   validators: (String? value) {
                                  //     if (value!.isNotEmpty) {
                                  //       return null;
                                  //     } else {
                                  //       return 'required'.tr;
                                  //     }
                                  //   },
                                  // ),
                                  TextFieldWidget(
                                    prefix: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.email_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: 'email'.tr,
                                    isReadOnly: controller.loginType.value ==
                                                "google" ||
                                            controller.loginType.value ==
                                                "apple"
                                        ? true
                                        : false,
                                    controller:
                                        controller.emailController.value,
                                    textInputType: TextInputType.emailAddress,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    validators: (String? value) {
                                      bool emailValid = RegExp(
                                              r'^.+@[a-zA-Z]+\.{1}[a-zA-Z]+(\.{0,1}[a-zA-Z]+)$')
                                          .hasMatch(value!);
                                      if (!emailValid) {
                                        return 'email not valid'.tr;
                                      } else {
                                        return null;
                                      }
                                    },
                                  ),
                                  controller.loginType.value == "google" ||
                                          controller.loginType.value == "apple"
                                      ? SizedBox()
                                      : TextFieldWidget(
                                          prefix: IconButton(
                                            onPressed: () {},
                                            icon: SvgPicture.asset(
                                              'assets/icons/ic_lock.svg',
                                              colorFilter: ColorFilter.mode(
                                                themeChange.getThem()
                                                    ? AppThemeData.grey500Dark
                                                    : AppThemeData.grey500,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                          hintText: 'password'.tr,
                                          controller: controller
                                              .passwordController.value,
                                          textInputType: TextInputType.text,
                                          obscureText: false,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 16),
                                          validators: (String? value) {
                                            if (value!.length >= 6) {
                                              return null;
                                            } else {
                                              return 'Password required at least 6 characters'
                                                  .tr;
                                            }
                                          },
                                        ),
                                  controller.loginType.value == "google" ||
                                          controller.loginType.value == "apple"
                                      ? SizedBox()
                                      : TextFieldWidget(
                                          prefix: IconButton(
                                            onPressed: () {},
                                            icon: SvgPicture.asset(
                                              'assets/icons/ic_lock.svg',
                                              colorFilter: ColorFilter.mode(
                                                themeChange.getThem()
                                                    ? AppThemeData.grey500Dark
                                                    : AppThemeData.grey500,
                                                BlendMode.srcIn,
                                              ),
                                            ),
                                          ),
                                          hintText: 'Confirm Password'.tr,
                                          controller: controller
                                              .conformPasswordController.value,
                                          textInputType: TextInputType.text,
                                          obscureText: false,
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  vertical: 16),
                                          validators: (String? value) {
                                            if (controller.passwordController
                                                    .value.text !=
                                                value) {
                                              return 'Confirm password is invalid'
                                                  .tr;
                                            } else {
                                              return null;
                                            }
                                          },
                                        ),

                                  Padding(
                                      padding: const EdgeInsets.only(top: 50),
                                      child: ButtonThem.buildButton(
                                        context,
                                        title: 'Sign up'.tr,
                                        btnHeight: 50,
                                        btnColor: AppThemeData.primary200,
                                        txtColor: Colors.white,
                                        onPress: () async {
                                          FocusScope.of(context).unfocus();
                                          if (_formKey.currentState!
                                              .validate()) {
                                            if (controller.phoneNumber.value
                                                .value.text.isEmpty) {
                                              ShowToastDialog.showToast(
                                                  "Phone number is empty");
                                            } else {
                                              Map<String, String> bodyParams = {
                                                'firstname': controller
                                                    .firstNameController
                                                    .value
                                                    .text
                                                    .trim()
                                                    .toString(),
                                                'lastname': controller
                                                    .lastNameController
                                                    .value
                                                    .text
                                                    .trim()
                                                    .toString(),
                                                'phone': controller.phoneNumber
                                                    .value.value.text
                                                    .trim(),
                                                'email': controller
                                                    .emailController.value.text
                                                    .trim(),
                                                'password': controller
                                                    .passwordController
                                                    .value
                                                    .text,
                                                'login_type':
                                                    controller.loginType.value,
                                                'tonotify': 'yes',
                                                'account_type': 'driver',
                                              };
                                              await controller
                                                  .signUp(bodyParams)
                                                  .then((value) {
                                                if (value != null) {
                                                  if (value.success ==
                                                      "success") {
                                                    Preferences.setInt(
                                                        Preferences.userId,
                                                        int.parse(value
                                                            .userData!.id
                                                            .toString()));
                                                    Preferences.setString(
                                                        Preferences.user,
                                                        jsonEncode(value));
                                                    Get.offAll(
                                                        const LoginScreen());
                                                  } else {
                                                    ShowToastDialog.showToast(
                                                        value.error);
                                                  }
                                                }
                                              });
                                            }
                                          }
                                        },
                                      )),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 20),
                              child: Text.rich(
                                textAlign: TextAlign.center,
                                TextSpan(
                                  text: 'Already book rides?'.tr,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontFamily: AppThemeData.regular,
                                    color: isDarkMode
                                        ? AppThemeData.grey800Dark
                                        : AppThemeData.grey800,
                                  ),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text: ' '.tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppThemeData.medium,
                                        color: AppThemeData.primary200,
                                      ),
                                    ),
                                    TextSpan(
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Get.offAll(
                                            const LoginScreen(),
                                            duration: const Duration(
                                                milliseconds: 400),
                                            transition: Transition.rightToLeft),
                                      text: 'Login'.tr,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontFamily: AppThemeData.medium,
                                        color: AppThemeData.primary200,
                                        decoration: TextDecoration.underline,
                                        decorationColor:
                                            AppThemeData.primary200,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
