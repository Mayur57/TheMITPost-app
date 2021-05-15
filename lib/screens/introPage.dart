import 'dart:math';

import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mit_post/anim/waveAnimation.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/strings.dart';
import 'package:mit_post/util/themes.dart';
import 'package:mit_post/widgets/miscCard.dart';
import 'package:provider/provider.dart';

class IntroPage extends StatefulWidget {
  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  static double heightFactor = 8.94;
  bool _deviceVibrationCapabilities = true;
  static double widthFactor = 4.31;
  bool hasUserSelectedTheme = false;
  double _featureTextSpacing = Scaler.scaleWidgetHeight(20, 8.94);
  double _featureTextSize = Scaler.scaleWidgetWidth(16, 4.31);
  int DARK_MODE_SELECTED = 1;
  int LIGHT_MODE_SELECTED = -1;
  int selectionState = 0;

  Image lightHeader = Image.asset(
    "assets/images/headers-02.png",
    width: Scaler.scaleWidgetWidth(300, widthFactor),
  );

  Image darkHeader = Image.asset(
    "assets/images/headers-01.png",
    width: Scaler.scaleWidgetWidth(300, widthFactor),
  );

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    return Center(
      child: Scaffold(
        backgroundColor: theme.cardColor,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            if (hasUserSelectedTheme) {
              Navigator.of(context).pushReplacementNamed("/root");
            } else {
              print("Please select theme bhenchod");
              _deviceVibrationCapabilities
                  ? Vibrate.feedback(FeedbackType.error)
                  : null;
              Fluttertoast.showToast(
                msg: "Please select a theme to continue!",
                gravity: ToastGravity.BOTTOM,
              );
            }
          },
          label: Text(
            "Let's go!",
            style: TextStyle(
                color: theme.colorScheme.primaryVariant, fontFamily: medium),
          ),
          icon: Icon(Icons.arrow_forward,
              color: theme.colorScheme.primaryVariant),
          backgroundColor: theme.cardColor,
        ),
        body: Stack(
          children: [
            positionBottom(
              Wave(
                height: 180,
                speed: 1.0,
              ),
            ),
            positionBottom(
              Wave(
                height: 100,
                speed: 0.9,
                offset: pi,
              ),
            ),
            positionBottom(
              Wave(
                height: 200,
                speed: 1.2,
                offset: pi / 2,
              ),
            ),
            positionBottom(
              Wave(
                height: 150,
                speed: 1.1,
                offset: -pi / 2,
              ),
            ),
            positionBottom(
              Wave(
                height: 100,
                speed: 0.8,
                offset: -pi,
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
            ),
            SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Align(
                alignment: Alignment.topCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  child: Column(
                    children: [
                      SizedBox(
                        height: Scaler.scaleWidgetHeight(70, heightFactor),
                      ),
                      darkMode
                          ? Padding(
                              padding: EdgeInsets.only(
                                top: Scaler.scaleWidgetHeight(
                                    30.0, heightFactor),
                                bottom: Scaler.scaleWidgetHeight(
                                    20.0, heightFactor),
                              ),
                              child: darkHeader,
                            )
                          : Padding(
                              padding: EdgeInsets.only(
                                top: Scaler.scaleWidgetHeight(
                                    30.0, heightFactor),
                                bottom: Scaler.scaleWidgetHeight(
                                    20.0, heightFactor),
                              ),
                              child: lightHeader,
                            ),
                      SizedBox(
                        height: _featureTextSpacing,
                      ),
                      Text(
                        "Welcome to The MIT Post app!",
                        style: theme.textTheme.headline3.copyWith(
                          fontSize: Scaler.scaleWidgetWidth(24, widthFactor),
                        ),
                      ),
                      SizedBox(
                        height: Scaler.scaleWidgetHeight(30, heightFactor),
                      ),
                      Text(
                        " • Read the latest articles written by our writing team",
                        style: theme.textTheme.bodyText1
                            .copyWith(fontSize: _featureTextSize),
                      ),
                      SizedBox(
                        height: _featureTextSpacing,
                      ),
                      Text(
                        " • Get notifications about important notices and alerts, anywhere, instantly!",
                        style: theme.textTheme.bodyText1
                            .copyWith(fontSize: _featureTextSize),
                      ),
                      SizedBox(
                        height: _featureTextSpacing,
                      ),
                      Text(
                        " • Stay up to date with all the events with our constantly updating Events tab",
                        style: theme.textTheme.bodyText1
                            .copyWith(fontSize: _featureTextSize),
                      ),
                      SizedBox(
                        height: _featureTextSpacing,
                      ),
                      Text(
                        " • See the latest and highest quality content we produce for Instagram and Twitter right in the app",
                        style: theme.textTheme.bodyText1
                            .copyWith(fontSize: _featureTextSize),
                      ),
                      SizedBox(
                        height: _featureTextSpacing,
                      ),
                      Text(
                        " • Industry standard security ensures best possible levels of user privacy",
                        style: theme.textTheme.bodyText1
                            .copyWith(fontSize: _featureTextSize),
                      ),
                      SizedBox(
                        height: Scaler.scaleWidgetHeight(30, heightFactor),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "Select a theme to get started:",
                          style: theme.textTheme.headline3.copyWith(
                              fontSize:
                                  Scaler.scaleWidgetWidth(20, widthFactor)),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                hasUserSelectedTheme = true;
                                selectionState = LIGHT_MODE_SELECTED;
                              });
                              _setThemeForStatusAndNavigation(true);
                              _deviceVibrationCapabilities
                                  ? Vibrate.feedback(FeedbackType.heavy)
                                  : null;
                              bool boolean = false;
                              Provider.of<AppThemeStateNotifier>(context)
                                  .updateTheme(boolean);
                              Fluttertoast.showToast(
                                msg: "Light mode enabled",
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                            child: Card(
                              color: AppTheme.mitPostOrange.withOpacity(0.5),
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                height:
                                    Scaler.scaleWidgetHeight(80, heightFactor),
                                width:
                                    Scaler.scaleWidgetHeight(130, heightFactor),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2.5,
                                    color: selectionState == LIGHT_MODE_SELECTED
                                        ? Colors.greenAccent
                                        : Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: selectionState ==
                                                  LIGHT_MODE_SELECTED
                                              ? Icon(
                                                  Icons.check_circle,
                                                  color: Colors.greenAccent,
                                                  size: Scaler.scaleWidgetWidth(
                                                      24, widthFactor),
                                                )
                                              : Icon(
                                                  FontAwesomeIcons
                                                      .solidLightbulb,
                                                  color: theme.colorScheme
                                                      .primaryVariant,
                                                  size: Scaler.scaleWidgetWidth(
                                                      22, widthFactor),
                                                ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Light\nMode',
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.headline3
                                              .copyWith(
                                            fontSize: Scaler.scaleWidgetWidth(
                                                16.0, widthFactor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                hasUserSelectedTheme = true;
                                selectionState = DARK_MODE_SELECTED;
                              });
                              _setThemeForStatusAndNavigation(false);
                              _deviceVibrationCapabilities
                                  ? Vibrate.feedback(FeedbackType.heavy)
                                  : null;
                              bool boolean = true;
                              Provider.of<AppThemeStateNotifier>(context)
                                  .updateTheme(boolean);
                              Fluttertoast.showToast(
                                msg: "Dark mode enabled",
                                gravity: ToastGravity.BOTTOM,
                              );
                            },
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              color: AppTheme.mitPostOrange.withOpacity(0.5),
                              semanticContainer: true,
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 2.5,
                                    color: selectionState == DARK_MODE_SELECTED
                                        ? Colors.greenAccent
                                        : Colors.transparent,
                                  ),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(10.0),
                                  ),
                                ),
                                height:
                                    Scaler.scaleWidgetHeight(80, heightFactor),
                                width:
                                    Scaler.scaleWidgetHeight(130, heightFactor),
                                child: Stack(
                                  children: <Widget>[
                                    Align(
                                      alignment: Alignment.topRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: selectionState ==
                                                  DARK_MODE_SELECTED
                                              ? Icon(
                                                  Icons.check_circle,
                                                  color: Colors.greenAccent,
                                                  size: Scaler.scaleWidgetWidth(
                                                      24, widthFactor),
                                                )
                                              : Icon(
                                                  FontAwesomeIcons.lightbulb,
                                                  color: theme.colorScheme
                                                      .primaryVariant,
                                                  size: Scaler.scaleWidgetWidth(
                                                      22, widthFactor),
                                                ),
                                        ),
                                      ),
                                    ),
                                    Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Dark\nMode",
                                          overflow: TextOverflow.ellipsis,
                                          style: theme.textTheme.headline3
                                              .copyWith(
                                            fontSize: Scaler.scaleWidgetWidth(
                                                16.0, widthFactor),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 5, vertical: 10),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: Scaler.scaleWidgetHeight(100, heightFactor),
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

  positionBottom(Widget child) =>
      Positioned.fill(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: child,
        ),
      );

  vibration() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _deviceVibrationCapabilities = canVibrate;
      _deviceVibrationCapabilities
          ? print("Device vibration is supported")
          : print("Device vibration is not supported");
    });
  }

  _setThemeForStatusAndNavigation(bool darkMode) {
    if (!darkMode) {
      FlutterStatusbarcolor.setNavigationBarColor(Color(0xFF17181C));
      FlutterStatusbarcolor.setStatusBarColor(Color(0xFF17181C));
    } else {
      FlutterStatusbarcolor.setNavigationBarColor(Color(0xFFFFFFFF));
      FlutterStatusbarcolor.setStatusBarColor(Color(0xFFFFFFFF));
    }
    FlutterStatusbarcolor.setStatusBarWhiteForeground(!darkMode);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(!darkMode);
  }
}
