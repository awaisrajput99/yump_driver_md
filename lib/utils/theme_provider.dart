import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'theme_preference.dart';

class ThemeProvider with ChangeNotifier {
  ThemePreferences themePreferences = ThemePreferences();

  int _darkTheme = 2; // 0 = Dark, 1 = Light, 2 = System (default)

  int get darkTheme => _darkTheme;

  set darkTheme(int value) {
    _darkTheme = value;
    themePreferences.setDarkTheme(value);
    notifyListeners();
  }

  /// Load the theme from SharedPreferences at app startup
  Future<void> loadTheme() async {
    await themePreferences.setDarkTheme(1); // Force it to light
    _darkTheme = await themePreferences.getTheme();
    debugPrint('🌗 Current Theme Preference: $_darkTheme');

    notifyListeners();
  }

  /// Returns true if the app should use dark theme, false for light
  bool getThem() {
    if (_darkTheme == 0) {
      return true; // Dark
    } else if (_darkTheme == 1) {
      return false; // Light
    } else {
      return getSystemTheme(); // Follow system theme
    }
  }

  /// Checks system brightness for when theme mode is "system"
  bool getSystemTheme() {
    var brightness =
        SchedulerBinding.instance.platformDispatcher.platformBrightness;
    return brightness == Brightness.dark;
  }
}