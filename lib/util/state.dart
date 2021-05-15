import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppThemeStateNotifier extends ChangeNotifier {
  bool isDarkMode = false;
  bool isVibrationAllowed = true;
  bool isFirstLaunchForUser = true;
  String keyTheme = "theme";
  String keyFirstTimeLogin = "login";
  String keyVibrate = "vib";
  SharedPreferences prefs;

  bool get darkModeState => isDarkMode;
  bool get vibrationPref => isVibrationAllowed;

  AppThemeStateNotifier() {
    isDarkMode = false;
    isVibrationAllowed = true;
    _loadThemeFromPrefs();
    _loadVibrationFromPrefs();
  }

  void updateTheme(bool toggle) {
    this.isDarkMode = toggle;
    _saveThemeToPrefs();
    notifyListeners();
  }

  void updateVibration(bool toggle) {
    this.isVibrationAllowed = toggle;
    _saveVibrationToPrefs();
    notifyListeners();
  }

  _initPrefs() async {
    if(prefs == null){
      prefs = await SharedPreferences.getInstance();
    }
  }

  _loadThemeFromPrefs() async {
    await _initPrefs();
    isDarkMode = prefs.getBool(keyTheme) ?? true;
    if (isDarkMode) {
      FlutterStatusbarcolor.setNavigationBarColor(Color(0xFF17181C));
      FlutterStatusbarcolor.setStatusBarColor(Color(0xFF17181C));
    } else {
      FlutterStatusbarcolor.setNavigationBarColor(Color(0xFFEFF0F5));
      FlutterStatusbarcolor.setStatusBarColor(Color(0xFFEFF0F5));
    }
    FlutterStatusbarcolor.setStatusBarWhiteForeground(isDarkMode);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(isDarkMode);
    notifyListeners();
  }

  _loadVibrationFromPrefs() async {
    await _initPrefs();
    isVibrationAllowed = prefs.getBool(keyVibrate) ?? true;
    notifyListeners();
  }

  _saveThemeToPrefs() async {
    await _initPrefs();
    prefs.setBool(keyTheme, isDarkMode);
  }

  _saveVibrationToPrefs() async {
    await _initPrefs();
    prefs.setBool(keyVibrate, isVibrationAllowed);
  }

  void updateLaunchState(bool toggle) {
    this.isFirstLaunchForUser = toggle;
    _saveThemeToPrefs();
    notifyListeners();
  }
}