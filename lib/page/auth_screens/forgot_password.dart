import 'package:yumprides_driver/constant/show_toast_dialog.dart';
import 'package:yumprides_driver/controller/forgot_password_controller.dart';
import 'package:yumprides_driver/page/auth_screens/forgot_password_otp_screen.dart';
import 'package:yumprides_driver/themes/button_them.dart';
import 'package:yumprides_driver/themes/constant_colors.dart';
import 'package:yumprides_driver/themes/responsive.dart';
import 'package:yumprides_driver/themes/text_field_them.dart';
import 'package:yumprides_driver/utils/dark_theme_provider.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final controller = Get.put(ForgotPasswordController());

  static final _formKey = GlobalKey<FormState>();
  static final _emailTextEditController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<DarkThemeProvider>(context);
    bool isDarkMode = themeChange.getThem();
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: Container(
        color: isDarkMode ? AppThemeData.surface50Dark : AppThemeData.surface50,
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
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text: 'First time in Yum Rides?'.tr,
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
                        ..onTap = () {
                          Get.back();
                        }, //transition effect);,
                      text: 'Create an account'.tr,
                      style: TextStyle(
                        fontSize: 16,
                        fontFamily: AppThemeData.medium,
                        color: AppThemeData.primary200,
                        decoration: TextDecoration.underline,
                        decorationColor: AppThemeData.primary200,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 50),
                      Text(
                        "Forgot Your Password?".tr,
                        // textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily: AppThemeData.semiBold,
                          color: isDarkMode
                              ? AppThemeData.secondary200
                              : AppThemeData.secondary200,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Don’t worry! Enter your email or mobile number, and we’ll help you reset your password."
                            .tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          fontFamily: AppThemeData.regular,
                          color: isDarkMode
                              ? AppThemeData.secondary200
                              : AppThemeData.secondary200,
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    color: isDarkMode
                        ? AppThemeData.surface50Dark
                        : AppThemeData.surface50,
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
                        controller: _emailTextEditController,
                        textInputType: TextInputType.emailAddress,
                        contentPadding: EdgeInsets.zero,
                        validators: (String? value) {
                          if (value!.isNotEmpty) {
                            return null;
                          } else {
                            return 'required'.tr;
                          }
                        },
                      ),
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(top: 50),
                        child: ButtonThem.buildButton(
                          context,
                          title: 'Send'.tr,
                          btnHeight: 50,
                          btnColor: AppThemeData.primary200,
                          txtColor: isDarkMode
                              ? AppThemeData.white90
                              : AppThemeData.grey80Dark,
                          onPress: () async {
                            FocusScope.of(context).unfocus();
                            if (_formKey.currentState!.validate()) {
                              Map<String, String> bodyParams = {
                                'email': _emailTextEditController.text.trim(),
                                'user_cat': "driver",
                              };
                              controller.sendEmail(bodyParams).then((value) {
                                if (value != null) {
                                  if (value == true) {
                                    Get.to(
                                        ForgotPasswordOtpScreen(
                                            email: _emailTextEditController.text
                                                .trim()),
                                        duration:
                                            const Duration(milliseconds: 400),
                                        //duration of transitions, default 1 sec
                                        transition: Transition.rightToLeft);
                                  } else {
                                    ShowToastDialog.showToast(
                                        "Please try again later");
                                  }
                                }
                              });
                            }
                          },
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
  }
}
