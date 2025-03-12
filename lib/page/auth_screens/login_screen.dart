import 'dart:convert';
import 'dart:io';

import 'package:yumprides_driver/constant/constant.dart';
import 'package:yumprides_driver/constant/show_toast_dialog.dart';
import 'package:yumprides_driver/controller/login_conroller.dart';
import 'package:yumprides_driver/model/user_model.dart';
import 'package:yumprides_driver/page/auth_screens/forgot_password.dart';
import 'package:yumprides_driver/page/dash_board.dart';
import 'package:yumprides_driver/themes/button_them.dart';
import 'package:yumprides_driver/themes/constant_colors.dart';
import 'package:yumprides_driver/themes/responsive.dart';
import 'package:yumprides_driver/themes/text_field_them.dart';
import 'package:yumprides_driver/utils/Preferences.dart';
import 'package:yumprides_driver/utils/dark_theme_provider.dart';
import 'package:yumprides_driver/widget/permission_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  static final _emailController = TextEditingController();
  static final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    return GetBuilder(
        init: LoginController(),
        initState: (state) async {
          try {
            PermissionStatus location = await Location().hasPermission();
            print(location);
            if (PermissionStatus.granted != location) {
              showDialogPermission(context);
            }
          } on PlatformException catch (e) {
            ShowToastDialog.showToast("${e.message}");
          }
          await requestTrackingPermission();
        },
        builder: (controller) {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: Colors.white,
            body: SafeArea(
              child: Stack(
                children: [
                  SizedBox(
                    // height: MediaQuery.of(context).size.he,
                    child: Column(
                      children: [
                        Container(
                          color: Colors.white,
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 20.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 50),
                                Text(
                                  "Welcome Back!".tr,
                                  textAlign: TextAlign.center,
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
                                  "Log in to your ${Constant.appName} account and continue your journey with seamless rides."
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
                              ],
                            ),
                          ),
                        ),
                        // const SizedBox(height: 100),
                        Expanded(
                          // flex: 4,
                          child: Container(
                            color: themeChange.getThem()
                                ? AppThemeData.surface50Dark
                                : AppThemeData.surface50,
                            child: Image.asset(
                              themeChange.getThem()
                                  ? 'assets/images/ic_bg_signup_dark.png'
                                  : 'assets/images/ic_bg_signup_light.png',
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ],
                    ),
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
                                  SizedBox(
                                    height: 60,
                                  ),
                                  TextFieldWidget(
                                    radius: BorderRadius.circular(12),
                                    prefix: IconButton(
                                      onPressed: () {},
                                      icon: Icon(
                                        Icons.email_outlined,
                                        color: Colors.black,
                                      ),
                                    ),
                                    hintText: 'email address'.tr,
                                    controller: _emailController,
                                    textInputType: TextInputType.emailAddress,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    validators: (String? value) {
                                      if (value!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'required'.tr;
                                      }
                                    },
                                  ),
                                  SizedBox(
                                    height: 12,
                                  ),
                                  TextFieldWidget(
                                    radius: BorderRadius.circular(12),
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
                                    hintText: 'enter password'.tr,
                                    controller: _passwordController,
                                    textInputType: TextInputType.text,
                                    obscureText: false,
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 16),
                                    validators: (String? value) {
                                      if (value!.isNotEmpty) {
                                        return null;
                                      } else {
                                        return 'required'.tr;
                                      }
                                    },
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        Get.to(
                                          ForgotPasswordScreen(),
                                          duration:
                                              const Duration(milliseconds: 400),
                                          transition: Transition.rightToLeft,
                                        );
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.only(top: 10),
                                        child: Text(
                                          "forgot password".tr,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: AppThemeData.secondary200,
                                            fontFamily: AppThemeData.regular,
                                            decorationColor:
                                                AppThemeData.secondary200,
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50),
                                    child: ButtonThem.buildButton(
                                      context,
                                      title: 'Log in'.tr,
                                      btnHeight: 50,
                                      btnColor: AppThemeData.primary200,
                                      // txtColor: AppThemeData.surface50,
                                      txtColor: AppThemeData.white90,

                                      onPress: () async {
                                        FocusScope.of(context).unfocus();
                                        if (_formKey.currentState!.validate()) {
                                          Map<String, String> bodyParams = {
                                            'email':
                                                _emailController.text.trim(),
                                            'mdp': _passwordController.text,
                                            'user_cat': "driver",
                                            'login_type': 'email'
                                          };
                                          await controller
                                              .loginAPI(bodyParams)
                                              .then((value) {
                                            if (value != null) {
                                              if (value.success == "success") {
                                                Preferences.setString(
                                                    Preferences.user,
                                                    jsonEncode(value));
                                                Preferences.setBoolean(
                                                    Preferences.isLogin, true);
                                                UserData? userData =
                                                    value.userData;
                                                Preferences.setInt(
                                                    Preferences.userId,
                                                    int.parse(userData!.id
                                                        .toString()));
                                                Get.offAll(DashBoard(),
                                                    duration: const Duration(
                                                        milliseconds: 400),
                                                    transition:
                                                        Transition.rightToLeft);
                                              } else {
                                                ShowToastDialog.showToast(
                                                    value.error);
                                              }
                                            }
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 20),
                                      child: Text(
                                        "or continue with".tr,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: themeChange.getThem()
                                              ? AppThemeData.grey400Dark
                                              : AppThemeData.grey400,
                                          fontFamily: AppThemeData.regular,
                                        ),
                                      ),
                                    ),
                                  ),
                                  // Padding(
                                  //   padding: const EdgeInsets.only(top: 40),
                                  //   child: ButtonThem.buildIconButtonWidget(
                                  //     context,
                                  //     title: 'Mobile Number'.tr,
                                  //     btnHeight: 50,
                                  //     btnColor: themeChange.getThem()
                                  //         ? AppThemeData.grey300Dark
                                  //         : AppThemeData.grey300,
                                  //     txtColor: themeChange.getThem()
                                  //         ? AppThemeData.grey900Dark
                                  //         : AppThemeData.grey900,
                                  //     iconColor: themeChange.getThem()
                                  //         ? AppThemeData.grey900Dark
                                  //         : AppThemeData.grey900,
                                  //     icon: SvgPicture.asset(
                                  //         "assets/icons/ic_phone_line.svg"),
                                  //     onPress: () {
                                  //       FocusScope.of(context).unfocus();
                                  //       Get.to(
                                  //           MobileNumberScreen(isLogin: true),
                                  //           duration: const Duration(
                                  //               milliseconds:
                                  //                   400), //duration of transitions, default 1 sec
                                  //           transition: Transition.rightToLeft);
                                  //     },
                                  //   ),
                                  // ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child:
                                              ButtonThem.buildIconButtonWidget(
                                            context,
                                            title: 'Google'.tr,
                                            btnColor: themeChange.getThem()
                                                ? AppThemeData.grey300Dark
                                                : AppThemeData.grey300,
                                            txtColor: themeChange.getThem()
                                                ? AppThemeData.grey900Dark
                                                : AppThemeData.grey900,
                                            onPress: () {
                                              FocusScope.of(context).unfocus();
                                              controller.loginWithGoogle();
                                            },
                                            iconColor: themeChange.getThem()
                                                ? AppThemeData.grey900Dark
                                                : AppThemeData.grey900,
                                            icon: SvgPicture.asset(
                                                "assets/icons/ic_google.svg"),
                                          ),
                                        ),
                                        SizedBox(
                                          width: Platform.isIOS ? 10 : 0,
                                        ),
                                        Platform.isIOS
                                            ? Expanded(
                                                child: ButtonThem
                                                    .buildIconButtonWidget(
                                                  context,
                                                  title: 'Apple'.tr,
                                                  btnColor: themeChange
                                                          .getThem()
                                                      ? AppThemeData.grey300Dark
                                                      : AppThemeData.grey300,
                                                  txtColor: themeChange
                                                          .getThem()
                                                      ? AppThemeData.grey900Dark
                                                      : AppThemeData.grey900,
                                                  iconColor: themeChange
                                                          .getThem()
                                                      ? AppThemeData.grey900Dark
                                                      : AppThemeData.grey900,
                                                  icon: SvgPicture.asset(
                                                      "assets/icons/ic_apple.svg"),
                                                  onPress: () {
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    controller.loginWithApple();
                                                  },
                                                ),
                                              )
                                            : SizedBox()
                                      ],
                                    ),
                                  )
                                ],
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
            // bottomNavigationBar: Padding(
            //   padding: const EdgeInsets.only(bottom: 20),
            //   child: Text.rich(
            //     textAlign: TextAlign.center,
            //     TextSpan(
            //       text: 'First time in ${Constant.appName}?'.tr,
            //       style: TextStyle(
            //         fontSize: 16,
            //         fontFamily: AppThemeData.regular,
            //         color: themeChange.getThem()
            //             ? AppThemeData.grey800Dark
            //             : AppThemeData.grey800,
            //       ),
            //       children: <TextSpan>[
            //         TextSpan(
            //           text: ' '.tr,
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontFamily: AppThemeData.medium,
            //             color: AppThemeData.primary200,
            //           ),
            //         ),
            //         TextSpan(
            //           recognizer: TapGestureRecognizer()
            //             ..onTap = () => Get.to(
            //                 MobileNumberScreen(
            //                   isLogin: false,
            //                 ),
            //                 duration: const Duration(
            //                     milliseconds:
            //                         400), //duration of transitions, default 1 sec
            //                 transition:
            //                     Transition.rightToLeft), //transition effect);,
            //           text: 'Create an account'.tr,
            //           style: TextStyle(
            //             fontSize: 16,
            //             fontFamily: AppThemeData.medium,
            //             color: AppThemeData.primary200,
            //             decoration: TextDecoration.underline,
            //             decorationColor: AppThemeData.primary200,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          );
        });
  }

  showDialogPermission(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const LocationPermissionDisclosureDialog(),
    );
  }
}
