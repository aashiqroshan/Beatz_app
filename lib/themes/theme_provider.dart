import 'package:beatz_musicplayer/themes/dark_mode.dart';
import 'package:beatz_musicplayer/themes/light_mode.dart';
import 'package:flutter/material.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeData = lightMode;
  ThemeData get themeData => _themeData;
  bool get isDarkMode => _themeData == DarkMode;
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeData == lightMode) {
      themeData = DarkMode;
    } else {
      themeData = lightMode;
    }
  }
}
