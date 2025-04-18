import 'package:flutter/material.dart';

import '../constant_colors.dart';

class MdElevatedButtonTheme{
  MdElevatedButtonTheme._();
  static final MdElevatedButtonThemeStyleLight = ElevatedButtonThemeData(
    style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        foregroundColor: Colors.white,
        backgroundColor: AppThemeData.primary200,
        side: BorderSide(color: AppThemeData.primary200,
            width: 2)
    ),
  );
  static final MdElevatedButtonThemeStyleDark = ElevatedButtonThemeData(
    style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        foregroundColor: Colors.white,
        backgroundColor: Colors.yellow,
        side: BorderSide(color: MdConstantColors.primaryDefault,
            width: 2)
    ),
  );
}