import 'dart:convert';
import 'dart:math';

import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/strings.dart';
import 'package:mit_post/util/themes.dart';
import 'package:mit_post/widgets/contactsCard.dart';
import 'package:mit_post/widgets/miscCard.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class ExtrasPage extends StatefulWidget {
  @override
  _ExtrasPageState createState() => _ExtrasPageState();
}

class _ExtrasPageState extends State<ExtrasPage> {
  bool _deviceVibrationCapabilities = true;

  static double heightFactor = 8.94;
  static double widthFactor = 4.31;
  Image header;
  int lastTap = DateTime.now().millisecondsSinceEpoch;
  int taps = 0;
  bool easterEggTriggered = false;

  ConfettiController _confetti;

  Image lightHeader = Image.asset(
    "assets/images/headers-02.png",
    width: Scaler.scaleWidgetWidth(300, widthFactor),
  );
  Image darkHeader = Image.asset(
    "assets/images/headers-01.png",
    width: Scaler.scaleWidgetWidth(300, widthFactor),
  );

  @override
  void initState() {
    super.initState();
    header = lightHeader;
    vibration();
    _confetti = ConfettiController(duration: Duration(seconds: 1));
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

  tripleTapGestureRecogniser() {
    int now = DateTime.now().millisecondsSinceEpoch;
    if (now - lastTap < 300) {
      print("Tap recognised");
      taps++;
      print("Taps: " + taps.toString());
      if (taps > 4) {
        print("Triple tap recognised");
        Navigator.of(context).pushNamed('/mag');
      } else {
        taps = 0;
      }
      lastTap = now;
    }
  }

  @override
  void dispose() {
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    bool shouldVibrate =
        Provider.of<AppThemeStateNotifier>(context).isVibrationAllowed;
    return Center(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body:
        Center(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Center(
                child: ConfettiWidget(
                  confettiController: _confetti,
                  blastDirectionality: BlastDirectionality.explosive,
                  maxBlastForce: 25,
                  minBlastForce: 10,
                  emissionFrequency: 0.05,
                  numberOfParticles: 200,
                  gravity: 0.1,
                  child: AnimationLimiter(
                    child: SafeArea(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 25,),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Row(
                                children: [
                                  SizedBox(width: 25,),
                                  Icon(
                                    Icons.arrow_back,
                                    color: Theme.of(context).colorScheme.primaryVariant,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20,),
                          darkMode
                              ? Padding(
                            padding: EdgeInsets.only(
                              top: Scaler.scaleWidgetHeight(30.0, heightFactor),
                              bottom:
                              Scaler.scaleWidgetHeight(20.0, heightFactor),
                            ),
                            child: GestureDetector(
                              child: darkHeader,
                              onLongPress: () {
                                _confetti.play();
                                Fluttertoast.showToast(
                                    msg:
                                    "🎉🎉🎉",
                                    gravity: ToastGravity.BOTTOM,
                                    toastLength: Toast.LENGTH_LONG);
                              },
                            ),
                          )
                              : Padding(
                            padding: EdgeInsets.only(
                              top: Scaler.scaleWidgetHeight(30.0, heightFactor),
                              bottom:
                              Scaler.scaleWidgetHeight(20.0, heightFactor),
                            ),
                            child: GestureDetector(
                              child: lightHeader,
                              onLongPress: () {
                                _confetti.play();
                                Fluttertoast.showToast(
                                    msg:
                                    "🎉🎉🎉",
                                    gravity: ToastGravity.BOTTOM,
                                    toastLength: Toast.LENGTH_LONG);
                              },
                            ),
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10.0),
                              child: ContactCard(),
                            ),
                          ),

                          ///The Standard
                          GestureDetector(
                            onTap: () {
                              shouldVibrate
                                  ? Vibrate.feedback(FeedbackType.heavy)
                                  : null;
                              Navigator.of(context).pushNamed('/mag');
                            },
                            child: Card(
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              child: Container(
                                height: Scaler.scaleWidgetHeight(100.0, heightFactor),
                                width: Scaler.scaleWidgetWidth(390.0, widthFactor),
                                child: darkMode
                                    ? Image.asset(
                                  "assets/images/magazine_dark.png",
                                  fit: BoxFit.fitWidth,
                                )
                                    : Image.asset(
                                  "assets/images/magazine_light.png",
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              elevation: 0,
                              margin: EdgeInsets.all(10),
                            ),
                          ),
                          Container(
                            width: Scaler.scaleWidgetWidth(430.0, widthFactor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                ///Playlist
                                GestureDetector(
                                  onTap: () {
                                    showPlaylistAlertDialog(context);
                                    shouldVibrate
                                        ? Vibrate.feedback(FeedbackType.heavy)
                                        : null;
                                  },
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Container(
                                      height:
                                      Scaler.scaleWidgetHeight(100.0, heightFactor),
                                      width:
                                      Scaler.scaleWidgetWidth(180.0, widthFactor),
                                      child: Stack(
                                        children: <Widget>[
                                          Container(
                                            height: Scaler.scaleWidgetHeight(
                                                120.0, heightFactor),
                                            width: Scaler.scaleWidgetWidth(
                                                400.0, widthFactor),
                                            child: Image.asset(
                                              "assets/images/playlist.jpg",
                                              fit: BoxFit.fill,
                                              color: Colors.black.withOpacity(0.6),
                                              colorBlendMode: BlendMode.darken,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                      right: Scaler.scaleWidgetWidth(
                                                          8.0, widthFactor),
                                                    ),
                                                    child: Icon(
                                                      Icons.music_note,
                                                      color: Colors.white,
                                                      size: Scaler.scaleWidgetWidth(
                                                          30.0, widthFactor),
                                                    ),
                                                  ),
                                                  Text(
                                                    "PLAYLISTS",
                                                    style: theme.textTheme.headline3
                                                        .copyWith(
                                                      fontFamily: "Gilroy-Bold",
                                                      letterSpacing: 0.75,
                                                      color: Colors.white,
                                                      fontSize: Scaler.scaleWidgetWidth(
                                                          16.0, widthFactor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 0,
                                    margin: EdgeInsets.only(bottom: 10, top: 10),
                                  ),
                                ),

                                ///Developers
                                GestureDetector(
                                  onTap: () {
                                    shouldVibrate
                                        ? Vibrate.feedback(FeedbackType.heavy)
                                        : null;
                                    Navigator.of(context).pushNamed('/dev');
                                  },
                                  child: Card(
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    child: Container(
                                      height:
                                      Scaler.scaleWidgetHeight(100.0, heightFactor),
                                      width:
                                      Scaler.scaleWidgetWidth(180.0, widthFactor),
                                      child: Stack(
                                        children: <Widget>[
                                          darkMode
                                              ? Container(
                                            height: Scaler.scaleWidgetHeight(
                                                120.0, heightFactor),
                                            width: Scaler.scaleWidgetWidth(
                                                400.0, widthFactor),
                                            child: Image.asset(
                                              "assets/images/grad.png",
                                              fit: BoxFit.fill,
                                              color:
                                              Colors.black.withOpacity(0.3),
                                              colorBlendMode: BlendMode.multiply,
                                            ),
                                          )
                                              : Container(
                                            height: Scaler.scaleWidgetHeight(
                                                120.0, heightFactor),
                                            width: Scaler.scaleWidgetWidth(
                                                400.0, widthFactor),
                                            child: Image.asset(
                                              "assets/images/grad.png",
                                              fit: BoxFit.fill,
                                              color:
                                              Colors.black.withOpacity(0.1),
                                              colorBlendMode: BlendMode.darken,
                                            ),
                                          ),
                                          Align(
                                            alignment: Alignment.center,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        right: Scaler.scaleWidgetWidth(
                                                            8.0, widthFactor)),
                                                    child: Icon(Icons.code,
                                                        color: Colors.white,
                                                        size: Scaler.scaleWidgetWidth(
                                                            30.0, widthFactor)),
                                                  ),
                                                  Text(
                                                    "THE\nDEVELOPERS",
                                                    style: theme.textTheme.headline3
                                                        .copyWith(
                                                        color: Colors.white,
                                                        fontFamily: "Gilroy-Bold",
                                                        letterSpacing: 0.75,
                                                        fontSize:
                                                        Scaler.scaleWidgetWidth(
                                                            15.0, widthFactor)),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    elevation: 0,
                                    margin: EdgeInsets.only(bottom: 10, top: 10),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ///Dark Mode
                              MiscCardSquare(
                                themeToggle: darkMode,
                                title: darkMode ? "LIGHT\nMODE" : "DARK\nMODE",
                                icon: Icon(
                                  !darkMode
                                      ? FontAwesomeIcons.lightbulb
                                      : FontAwesomeIcons.solidLightbulb,
                                  color: theme.colorScheme.primaryVariant,
                                  size: Scaler.scaleWidgetWidth(22, widthFactor),
                                ),
                                onTap: () {
                                  _setThemeForStatusandNavigation(darkMode);
                                  shouldVibrate
                                      ? Vibrate.feedback(FeedbackType.heavy)
                                      : null;
                                  bool boolean = darkMode ? false : true;
                                  Provider.of<AppThemeStateNotifier>(context)
                                      .updateTheme(boolean);
                                },
                              ),

                              ///Academic Calender
                              MiscCardSquare(
                                themeToggle: darkMode,
                                title: "ACADEMIC\nCALENDER",
                                icon: Icon(
                                  FontAwesomeIcons.calendar,
                                  color: theme.colorScheme.primaryVariant,
                                  size: Scaler.scaleWidgetWidth(22, widthFactor),
                                ),
                                onTap: () async {
                                  shouldVibrate
                                      ? Vibrate.feedback(FeedbackType.heavy)
                                      : null;
                                  var response = await http.get(
                                      "https://app.themitpost.com/academic_calendar");
                                  var responseBody = jsonDecode(response.body);
                                  if (responseBody['latest']) {
                                    if (await canLaunch(responseBody['imageUrl'])) {
                                      await launch(responseBody['imageUrl']);
                                    } else {
                                      throw 'Could not launch the Academic Calendar';
                                    }
                                  } else {
                                    shouldVibrate
                                        ? Vibrate.feedback(FeedbackType.error)
                                        : null;
                                    Fluttertoast.showToast(
                                      msg:
                                      "The college administration is yet to upload the Academic Calendar for ${responseBody['year']}.",
                                      gravity: ToastGravity.CENTER,
                                    );
                                  }
                                },
                              ),

                              ///Our Website
                              MiscCardSquare(
                                themeToggle: darkMode,
                                title: "OUR\nWEBSITE",
                                icon: Icon(
                                  FontAwesomeIcons.externalLinkAlt,
                                  color: theme.colorScheme.primaryVariant,
                                  size: Scaler.scaleWidgetWidth(22, widthFactor),
                                ),
                                onTap: () async {
                                  shouldVibrate
                                      ? Vibrate.feedback(FeedbackType.heavy)
                                      : null;
                                  var url = "https://www.themitpost.com/";
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              ///Privacy Policy
                              MiscCardSquare(
                                themeToggle: darkMode,
                                title: "PRIVACY\nPOLICY",
                                icon: Icon(
                                  FontAwesomeIcons.handHoldingHeart,
                                  color: theme.colorScheme.primaryVariant,
                                  size: Scaler.scaleWidgetWidth(22, widthFactor),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed("/priv");
                                },
                              ),

                              ///About Us
                              MiscCardSquare(
                                themeToggle: darkMode,
                                title: "ABOUT US",
                                icon: Icon(
                                  FontAwesomeIcons.solidHeart,
                                  color: theme.colorScheme.primaryVariant,
                                  size: Scaler.scaleWidgetWidth(22, widthFactor),
                                ),
                                onTap: () {
                                  Navigator.of(context).pushNamed('/about');
                                },
                              ),

                              ///Report a bug
                              MiscCardSquare(
                                themeToggle: darkMode,
                                title: "REPORT\nA BUG",
                                icon: Icon(FontAwesomeIcons.bug,
                                    color: theme.colorScheme.primaryVariant,
                                    size: Scaler.scaleWidgetWidth(22, widthFactor)),
                                onTap: () async {
                                  shouldVibrate
                                      ? Vibrate.feedback(FeedbackType.heavy)
                                      : null;
                                  var url =
                                      "mailto:developers.themitpost@gmail.com?subject=Bug: <brief bug description here>&body=<--please replace this text and describe your issue in detail along with your name and phone model-->";
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                              ),
                            ],
                          ),

                          ///Vibration Toggle
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                bool boolean = shouldVibrate ? false : true;
                                Provider.of<AppThemeStateNotifier>(context)
                                    .updateVibration(boolean);
                              });
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: 60,
                              child: Card(
                                color: darkMode ? Color(0xFF2F2F34) : Colors.black.withOpacity(0.03),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    width: 1,
                                    color: darkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
                                  ),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 0,
                                child: Center(
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.vibration,
                                              color: theme.colorScheme.primaryVariant,
                                              size: Scaler.scaleWidgetWidth(
                                                  18, widthFactor),
                                            ),
                                            SizedBox(
                                              width: Scaler.scaleWidgetWidth(
                                                  10, widthFactor),
                                            ),
                                            Text(
                                              "HAPTICS",
                                              overflow: TextOverflow.ellipsis,
                                              style: theme.textTheme.headline3.copyWith(
                                                fontFamily: "Gilroy-Bold",
                                                letterSpacing: 0.75,
                                                fontSize: Scaler.scaleWidgetWidth(
                                                    15.0, widthFactor),
                                              ),
                                            ),
                                          ],
                                        ),
                                        shouldVibrate
                                            ? Text(
                                          "ENABLED",
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                          theme.textTheme.headline3.copyWith(
                                            fontFamily: "Gilroy",
                                            letterSpacing: 0.9,
                                            color: darkMode ? Colors.greenAccent : Colors.green[700],
                                            fontSize: Scaler.scaleWidgetWidth(
                                                14.0, widthFactor),
                                          ),
                                        )
                                            : Text(
                                          "DISABLED",
                                          overflow: TextOverflow.ellipsis,
                                          style:
                                          theme.textTheme.headline3.copyWith(
                                            color: darkMode ? Colors.redAccent : Colors.red[600],
                                            fontFamily: "Gilroy",
                                            letterSpacing: 0.9,
                                            fontSize: Scaler.scaleWidgetWidth(
                                                14.0, widthFactor),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              margin: EdgeInsets.only(
                                left: 16,
                                right: 16,
                                top: 4,
                                bottom: 4,
                              ),
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 60,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed('/changelog');
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.445,
                                    child: Card(
                                      color: darkMode ? Color(0xFF2F2F34) : Colors.black.withOpacity(0.03),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          color: darkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
                                        ),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      elevation: 0,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.notes,
                                                    color: theme.colorScheme.primaryVariant,
                                                    size: Scaler.scaleWidgetWidth(
                                                        18, widthFactor),
                                                  ),
                                                  SizedBox(
                                                    width: Scaler.scaleWidgetWidth(
                                                        10, widthFactor),
                                                  ),
                                                  Text(
                                                    "CHANGELOG",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: theme.textTheme.headline3.copyWith(
                                                      fontFamily: "Gilroy-Bold",
                                                      letterSpacing: 0.75,
                                                      fontSize: Scaler.scaleWidgetWidth(
                                                          15.0, widthFactor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),


                                GestureDetector(
                                  onTap: () {
                                    launch("https://github.com/Mayur57/TheMITPost-app");
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width * 0.445,
                                    child: Card(
                                      color: darkMode ? Color(0xFF2F2F34) : Colors.black.withOpacity(0.03),
                                      shape: RoundedRectangleBorder(
                                        side: BorderSide(
                                          width: 1,
                                          color: darkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
                                        ),
                                        borderRadius: BorderRadius.circular(10.0),
                                      ),
                                      elevation: 0,
                                      child: Center(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    Icons.code,
                                                    color: theme.colorScheme.primaryVariant,
                                                    size: Scaler.scaleWidgetWidth(
                                                        18, widthFactor),
                                                  ),
                                                  SizedBox(
                                                    width: Scaler.scaleWidgetWidth(
                                                        10, widthFactor),
                                                  ),
                                                  Text(
                                                    "SOURCE CODE",
                                                    overflow: TextOverflow.ellipsis,
                                                    style: theme.textTheme.headline3.copyWith(
                                                      fontFamily: "Gilroy-Bold",
                                                      letterSpacing: 0.75,
                                                      fontSize: Scaler.scaleWidgetWidth(
                                                          15.0, widthFactor),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Container(),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            margin: EdgeInsets.only(
                              left: 16,
                              right: 16,
                              top: 4,
                              bottom: 4,
                            ),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 15,
                            child: Center(
                              child: Text(
                                "MADE WITH 🧡 BY THE MIT POST",
                                style: TextStyle(
                                  fontSize: Scaler.scaleWidgetWidth(12.0, widthFactor),
                                  color:  darkMode
                                      ? Colors.white.withOpacity(0.4)
                                      : Colors.black.withOpacity(0.6),
                                  fontFamily: medium,
                                  letterSpacing: 1.35,
                                ),
                              ),
                            ),
                            margin: EdgeInsets.only(left: 16, right: 16, top: 20),
                          ),

                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Center(
                              child: Text(
                                "APP VERSION: v3.1.0",
                                style: TextStyle(
                                  fontSize: Scaler.scaleWidgetWidth(12.0, widthFactor),
                                  color:  darkMode
                                      ? Colors.white.withOpacity(0.4)
                                      : Colors.black.withOpacity(0.6),
                                  fontFamily: medium,
                                  letterSpacing: 1.35,
                                ),
                              ),
                            ),
                            margin:
                            EdgeInsets.only(left: 16, right: 16, bottom: 0, top:1),
                          ),

                          SizedBox(
                            height: Scaler.scaleWidgetHeight(120, heightFactor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _setThemeForStatusandNavigation(bool darkmode) {
    /// TODO
    /// Check for the @whiteStatusBarIcons issue and
    /// implement a fix.
    assert(darkmode != null);
    if (!darkmode) {
      FlutterStatusbarcolor.setNavigationBarColor(Color(0xFF17181C));
      FlutterStatusbarcolor.setStatusBarColor(Color(0xFF17181C));
    } else {
      FlutterStatusbarcolor.setNavigationBarColor(Color(0xFFEFF0F5));
      FlutterStatusbarcolor.setStatusBarColor(Color(0xFFEFF0F5));
    }
    FlutterStatusbarcolor.setStatusBarWhiteForeground(!darkmode);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(!darkmode);
  }

  ///TODO: Scaling is remaining from here
  ///
  /// Add this to the app once all the pending features are implemented.
  showVoidAlertDialog(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Widget okay = FlatButton(
      child: Text(
        "Awesome!",
        style: TextStyle(
            fontFamily: medium, color: theme.colorScheme.primaryVariant),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      contentTextStyle: theme.textTheme.bodyText1.copyWith(fontSize: 16),
      titleTextStyle: theme.textTheme.headline3.copyWith(fontSize: 20),
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(16),
      actionsPadding: const EdgeInsets.all(0),
      title: Center(child: Text("You found Void!")),
      backgroundColor: theme.cardColor,
      content: Container(
        height: 200,
        width: 350,
        color: Colors.red,
      ),
      actions: [
        okay,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showPlaylistAlertDialog(BuildContext context) {
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    bool shouldVibrate =
        Provider.of<AppThemeStateNotifier>(context).isVibrationAllowed;
    ThemeData theme = Theme.of(context);
    Widget okay = FlatButton(
      child: Text(
        "Cancel",
        style: TextStyle(
            fontFamily: medium, color: theme.colorScheme.primaryVariant),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      contentTextStyle: theme.textTheme.bodyText1.copyWith(fontSize: 16),
      titleTextStyle: theme.textTheme.headline3.copyWith(fontSize: 20),
      titlePadding: const EdgeInsets.all(16),
      contentPadding: const EdgeInsets.all(8),
      actionsPadding: const EdgeInsets.all(0),
      title: Center(
        child: Text("Choose a playlist:"),
      ),
      backgroundColor: theme.cardColor,
      content: Container(
        height: 100,
        width: 350,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MiscCard(
              title: "Unwind",
              themeToggle: darkMode,
              icon: null,
              height: 115,
              width: 145,
              onTap: () async {
                shouldVibrate ? Vibrate.feedback(FeedbackType.heavy) : null;
                var url =
                    "https://open.spotify.com/playlist/6FFJblOyRN5zPGfiPp39Zj?si=0r6HC3t1RM2oE_eTHtpbnw";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
            MiscCard(
              title: "Study",
              themeToggle: darkMode,
              icon: null,
              height: 115,
              width: 145,
              onTap: () async {
                shouldVibrate ? Vibrate.feedback(FeedbackType.heavy) : null;
                var url =
                    "https://open.spotify.com/playlist/47z3uheG8SYnfk1irwNQR0?si=omnrQeR5TMeEx7mcLnPXLQ";
                if (await canLaunch(url)) {
                  await launch(url);
                } else {
                  throw 'Could not launch $url';
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        okay,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

class WebViewPage extends StatefulWidget {
  final String url;

  const WebViewPage({this.url});

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  bool _showProgressIndicator = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ModalProgressHUD(
        progressIndicator: CircularProgressIndicator(),
        color: Colors.black,
        opacity: 0.7,
        inAsyncCall: _showProgressIndicator,
        child: Scaffold(
          body: WebView(
            initialUrl: widget.url,
            onPageFinished: (String url) {
              setState(() {
                _showProgressIndicator = false;
              });
            },
          ),
        ),
      ),
    );
  }
}
