import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mit_post/util/state.dart';
import 'package:provider/provider.dart';

class DarkModeIconButton extends StatefulWidget {
  @override
  _DarkModeIconButtonState createState() => _DarkModeIconButtonState();
}

class _DarkModeIconButtonState extends State<DarkModeIconButton> {
  bool _deviceVibrationCapabilities = true;

  @override
  void initState() {
    super.initState();
    vibration();
  }

  vibration() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _deviceVibrationCapabilities = canVibrate;
      _deviceVibrationCapabilities
          ? print("Device vibration is supported")
          : print("Device vibration is not supported");
    });
  }

  _setThemeForStatusandNavigation(bool darkmode) {
    if (!darkmode) {
      FlutterStatusbarcolor.setNavigationBarColor(Color(0xFF17181C));
      FlutterStatusbarcolor.setStatusBarColor(Color(0xFF17181C));
    } else {
      FlutterStatusbarcolor.setNavigationBarColor(Color(0xFFFFFFFF));
      FlutterStatusbarcolor.setStatusBarColor(Color(0xFFFFFFFF));
    }
    FlutterStatusbarcolor.setStatusBarWhiteForeground(!darkmode);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(!darkmode);
  }

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    return Padding(
      padding: const EdgeInsets.only(right: 10.0),
      child: IconButton(
          tooltip: darkMode ? "Toggle Light Mode" : "Toggle Dark Mode",
          icon: darkMode
              ? Icon(
                  Icons.nights_stay_outlined,
                  color: Colors.grey,
                )
              : Icon(
                  Icons.wb_sunny_outlined,
                  color: Colors.grey,
                ),
          onPressed: () {
            _setThemeForStatusandNavigation(darkMode);
            _deviceVibrationCapabilities
                ? Vibrate.feedback(FeedbackType.heavy)
                : null;
            bool boolean = darkMode ? false : true;
            Provider.of<AppThemeStateNotifier>(context).updateTheme(boolean);
          }),
    );
  }
}
