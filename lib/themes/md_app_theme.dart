import 'package:flutter/material.dart';
import 'package:yumprides_driver/themes/styles/elevated_button_theme.dart';
import 'package:yumprides_driver/themes/styles/outlined_button_theme.dart';
import 'package:yumprides_driver/themes/styles/text_sizes_theme.dart';

class MdAppTheme {
  MdAppTheme._();

  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    textTheme: MdTextTheme.lightTextTheme,
    elevatedButtonTheme: MdElevatedButtonTheme.MdElevatedButtonThemeStyleLight,
    outlinedButtonTheme: MdOutlinedButtonTheme.mdOutlinedButtonThemeStyleLight
    // add other light theme settings here
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    textTheme: MdTextTheme.darkTextTheme,
    elevatedButtonTheme: MdElevatedButtonTheme.MdElevatedButtonThemeStyleDark,
    // add other dark theme settings here
  );
}