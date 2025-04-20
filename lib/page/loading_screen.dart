
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../constant/constant.dart';
import '../themes/constant_colors.dart';
import '../themes/responsive.dart';
import '../utils/theme_provider.dart';

class LoadingScreen extends StatelessWidget {
  final dynamic controller;
  const LoadingScreen({required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final themeChange = Provider.of<ThemeProvider>(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppThemeData.loadingBgColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(height: Responsive.height(10, context)),
          Image.asset(
            'assets/images/init_car_gif_md.gif',
            width: Responsive.width(70, context),
            height: Responsive.width(50, context),
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 30),
          Constant.loader(
            context,
            loadingcolor: themeChange.getThem()
                ? AppThemeData.grey400
                : AppThemeData.grey400Dark,
            bgColor: AppThemeData.loadingBgColor, isDarkMode: false,
          ),
          Text(
            'loading'.tr,
            style: TextStyle(
              color: themeChange.getThem()
                  ? AppThemeData.grey400
                  : AppThemeData.grey400Dark,
              fontSize: 16,
              fontFamily: AppThemeData.light,
            ),
            textAlign: TextAlign.center,
          ),
          Text(
            controller.isLoading.value.toString(),
            style: const TextStyle(
              color: Colors.transparent,
              fontSize: 0,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
