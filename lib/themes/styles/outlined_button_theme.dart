import 'package:flutter/material.dart';

import '../constant_colors.dart';


class MdOutlinedButtonTheme{
  MdOutlinedButtonTheme._(); // to avoid creating instances

// light theme
  static final mdOutlinedButtonThemeStyleLight = OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
        padding: const EdgeInsets.all(10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        foregroundColor: AppThemeData.primary200,
        side: BorderSide(color: AppThemeData.primary200,width: 2)
    ),
  );

//dark theme

}