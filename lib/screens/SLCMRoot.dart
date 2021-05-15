import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:mit_post/widgets/appBar.dart';
import 'package:mit_post/widgets/attendanceBottomSheet.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mit_post/models/Attendance.dart';
import 'package:mit_post/models/Slcm.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/strings.dart';
import 'package:mit_post/util/themes.dart';
import 'package:mit_post/widgets/attendanceCard.dart';
import 'package:mit_post/widgets/darkModeAppBarIcon.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class SLCMRoot extends StatefulWidget {
  @override
  _SLCMRootState createState() => _SLCMRootState();
}

class _SLCMRootState extends State<SLCMRoot>
    with AutomaticKeepAliveClientMixin<SLCMRoot> {
  @override
  bool get wantKeepAlive => true;

  Future<Response> futureAttendance;
  Slcm slcmData = Slcm();
  Future<Slcm> futureCaptcha;
  String registration;
  String password;
  String token;
  bool _passwordVisible = false;
  bool isLoggedIn = false;
  bool shouldShowRefreshWarning = true;
  bool _deviceVibrationCapabilities = true;
  int registrationValidator;
  bool isPasswordValid = true;
  bool isCaptchaValid = true;
  bool oldCaptcha = true;

  final _textReg = TextEditingController();
  final _textPass = TextEditingController();
  final _textCap = TextEditingController();

  static double heightFactor = 8.94;
  static double widthFactor = 4.31;

  Timer _timer;
  bool timeout = false;

  Image lightHeader = Image.asset(
    "assets/images/headers-02.png",
    width: Scaler.scaleWidgetWidth(300, widthFactor),
  );

  Image darkHeader = Image.asset(
    "assets/images/headers-01.png",
    width: Scaler.scaleWidgetWidth(300, widthFactor),
  );

  _checkCache() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn =
          prefs.getBool('SLCM') == null ? false : prefs.getBool('SLCM');
      futureAttendance = fetchAttendance(slcmData);
    });
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

  setLoggedInState(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoggedIn = state;
      prefs.setBool('SLCM', state);
    });
  }

  getRefreshVar() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool haha;
    haha = prefs.getBool('refreshAlertState');
    return haha;
  }

  setRefreshVar(bool state) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (state != null) {
      prefs.setBool('refreshAlertState', state);
    }
  }

  _timeout() {
    _timer = new Timer(const Duration(seconds: 8), () {
      setState(() {
        timeout = true;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    vibration();
    _passwordVisible = false;
    _checkCache();
  }

  @override
  void dispose() {
    _textReg.dispose();
    _textPass.dispose();
    _textCap.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    TextStyle _labelStyle = theme.textTheme.bodyText2.copyWith(
      fontFamily: regular,
      color: theme.colorScheme.primaryVariant,
    );
    TextStyle _hintStyle = theme.textTheme.bodyText2.copyWith(
      fontFamily: regular,
    );
    TextStyle _helperStyle = theme.textTheme.bodyText2.copyWith(
      fontFamily: regular,
      color: theme.colorScheme.primaryVariant,
      fontSize: 12,
    );
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Center(
        child: Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          // appBar: MyAppBar(
          //   title: 'SLCM',
          // ),
          floatingActionButton: isLoggedIn
              ? FloatingActionButton(
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      setLoggedInState(false);
                      oldCaptcha = true;
                      _textCap.clear();
                    });
                  },
                  backgroundColor: AppTheme.mitPostOrange,
                )
              : Container(),
          body: !isLoggedIn
              ? Padding(
                  padding: EdgeInsets.all(26),
                  child: SingleChildScrollView(
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SizedBox(height: 40,),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.925,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                "SLCM",
                                style: theme.textTheme.headline1,
                              ),
                              // Container(width: 200,),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 4.0),
                                child: IconButton(
                                    tooltip: "Miscellaneous",
                                    icon: Icon(
                                      Icons.dashboard_outlined,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () {
                                      Navigator.pushNamed(context, "/misc");
                                    }),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 20,),
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
                          height: Scaler.scaleWidgetHeight(30.0, heightFactor),
                        ),
                        TextField(
                          controller: _textReg,
                          keyboardType: TextInputType.number,
                          style: _hintStyle.copyWith(
                            color: theme.appBarTheme.iconTheme.color,
                            fontSize: 16,
                            fontFamily: medium,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            labelStyle: _labelStyle,
                            hintStyle: _hintStyle,
                            helperStyle: _helperStyle,
                            prefixIcon: Icon(
                              FontAwesomeIcons.hashtag,
                              size: 18,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            labelText: 'Registration Number',
                            // helperText: 'Enter your MIT registration number',
                            errorText:
                                parseValidationErrors(registrationValidator),
                            errorStyle:
                                _helperStyle.copyWith(color: Colors.redAccent),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onChanged: (text) {
                            registration = text;
                          },
                        ),
                        SizedBox(
                          height: Scaler.scaleWidgetHeight(25.0, heightFactor),
                        ),
                        TextField(
                          controller: _textPass,
                          keyboardType: TextInputType.visiblePassword,
                          style: _hintStyle.copyWith(
                            color: theme.appBarTheme.iconTheme.color,
                            fontSize: 16,
                            fontFamily: medium,
                          ),
                          obscureText: !_passwordVisible,
                          decoration: InputDecoration(
                            isDense: true,
                            labelStyle: _labelStyle,
                            hintStyle: _hintStyle,
                            helperStyle: _helperStyle,
                            prefixIcon: Icon(
                              FontAwesomeIcons.lock,
                              size: 18,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context)
                                    .appBarTheme
                                    .iconTheme
                                    .color,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                            errorText: !isPasswordValid
                                ? "Please enter your SLCM password"
                                : null,
                            errorStyle:
                                _helperStyle.copyWith(color: Colors.redAccent),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10)),
                            labelText: 'SLCM Password',
                          ),
                          onChanged: (text) {
                            password = text;
                          },
                        ),
                        SizedBox(
                          height: Scaler.scaleWidgetHeight(25.0, heightFactor),
                        ),
                        TextField(
                          controller: _textCap,
                          textCapitalization: TextCapitalization.characters,
                          style: _hintStyle.copyWith(
                            color: theme.appBarTheme.iconTheme.color,
                            fontSize: 16,
                            fontFamily: medium,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            prefixIcon: Icon(
                              Icons.remove_red_eye_outlined,
                              size: 18,
                            ),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8)),
                            labelStyle: _labelStyle,
                            hintStyle: _hintStyle,
                            errorText: !isCaptchaValid
                                ? "Please enter the CAPTCHA characters shown below"
                                : null,
                            errorStyle:
                                _helperStyle.copyWith(color: Colors.redAccent),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.redAccent),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            helperStyle: _helperStyle,
                            labelText: 'CAPTCHA',
                            // helperText: "Enter the characters seen below",
                          ),
                          onChanged: (text) {
                            token = text;
                          },
                        ),
                        SizedBox(
                          height: Scaler.scaleWidgetHeight(15.0, heightFactor),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            MaterialButton(
                              elevation: 0,
                              height: 45,
                              color: theme.textTheme.bodyText1.color.withOpacity(0.1),
                              splashColor: AppTheme.mitPostOrange,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(
                                      color: theme.textTheme.bodyText1.color.withOpacity(0.2), width: 1,)),
                              onPressed: () {
                                _deviceVibrationCapabilities
                                    ? Vibrate.feedback(FeedbackType.heavy)
                                    : null;
                                Fluttertoast.showToast(
                                    msg: "Fetching CAPTCHA...");
                                setState(() {
                                  slcmData.imageUrl = '';
                                  futureCaptcha = slcmData.getCaptcha();
                                  oldCaptcha = false;
                                });
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh_outlined,
                                    size: 16,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text(
                                    'GENERATE CAPTCHA',
                                    style: theme.textTheme.bodyText1.copyWith(
                                      letterSpacing: 1.35,
                                      color: theme.textTheme.bodyText1.color.withOpacity(0.7),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: Scaler.scaleWidgetHeight(25.0, heightFactor),
                        ),
                        oldCaptcha
                            ? Text('Please generate CAPTCHA')
                            : FutureBuilder(
                                future: futureCaptcha,
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    if (slcmData.success == true) {
                                      return Stack(
                                        children: [
                                          Center(
                                            child: SizedBox(
                                              child:
                                                  CircularProgressIndicator(),
                                              height: 10,
                                              width: 10,
                                            ),
                                            heightFactor: 2,
                                          ),
                                          Center(
                                            child: FadeInImage.memoryNetwork(
                                              placeholder: kTransparentImage,
                                              image: slcmData.imageUrl,
                                            ),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Center(
                                        child: Image.asset(darkMode
                                            ? 'assets/images/busy-dark.png'
                                            : 'assets/images/busy-light.png'),
                                      );
                                    }
                                  } else {
                                    return Center(
                                      child: Text('Please generate CAPTCHA'),
                                    );
                                  }
                                },
                              ),
                        SizedBox(
                          height: Scaler.scaleWidgetHeight(15.0, heightFactor),
                        ),
                        SizedBox(
                          height: Scaler.scaleWidgetHeight(15.0, heightFactor),
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            RaisedButton(
                              elevation: 0,
                              color: AppTheme.mitPostOrange.withOpacity(0.2),
                              shape: RoundedRectangleBorder(
                                side: BorderSide(
                                  width: 1,
                                  color: AppTheme.mitPostOrange.withOpacity(0.45),
                                ),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              onPressed: () async {
                                setState(() {
                                  futureAttendance = fetchAttendance(slcmData);
                                  registrationValidator =
                                      _validateRegistrationNumber(
                                          _textReg.text);
                                  isPasswordValid = _textPass.text.isNotEmpty;
                                  isCaptchaValid = _textCap.text.isNotEmpty;
                                });
                                if (registrationValidator == -1 &&
                                    isPasswordValid &&
                                    isCaptchaValid) {
                                  setLoggedInState(true);
                                  slcmData.setCredentials(
                                      token, registration, password);
                                  _deviceVibrationCapabilities
                                      ? Vibrate.feedback(FeedbackType.success)
                                      : null;
                                } else {
                                  _deviceVibrationCapabilities
                                      ? Vibrate.feedback(FeedbackType.error)
                                      : null;
                                }
                                _timeout();
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(14.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'LOGIN',
                                      style: theme.textTheme.bodyText1.copyWith(
                                        letterSpacing: 1.35,
                                        color: theme.textTheme.bodyText1.color.withOpacity(0.7),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )
              : FutureBuilder(
                  future: futureAttendance,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      timeout = false;
                      if (!snapshot.data.success) {
                        setLoggedInState(true);
                        return Center(
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.65,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/cat-07.png",
                                  height: 200,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Cannot verify user",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headline3,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  "Could not log you into SLCM. Please check your credentials and try again.",
                                  textAlign: TextAlign.center,
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: MaterialButton(
                                    onPressed: () {
                                      timeout = false;
                                      setLoggedInState(false);
                                      oldCaptcha = true;
                                      _textCap.clear();
                                    },
                                    minWidth: 30,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.refresh),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Text("Retry"),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      } else {
                        if (snapshot.data.attendance.length == 1) {
                          return Center(
                            child: Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/cat-07.png",
                                    height: 200,
                                  ),
                                  SizedBox(
                                    height: 15,
                                  ),
                                  Text(
                                    "Attendance data not found.",
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.headline3,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    "Looks like SLCM might be under maintenance, try again in some time.",
                                    textAlign: TextAlign.center,
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: MaterialButton(
                                      onPressed: () {
                                        timeout = false;
                                        setLoggedInState(false);
                                        oldCaptcha = true;
                                        _textCap.clear();
                                      },
                                      minWidth: 30,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.refresh),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text("Retry"),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        } else {
                          return ListView.builder(
                            physics: BouncingScrollPhysics(),
                            itemCount: snapshot.data.attendance.length,
                            itemBuilder: (BuildContext context, int index) {
                              if (index == 0) {
                                return Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 10, 8, 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(height: 40,),
                                      Container(
                                        width: MediaQuery.of(context).size.width * 0.925,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              _capitalise(snapshot.data.name),
                                              style: theme.textTheme.headline1,
                                            ),
                                            // Container(width: 200,),
                                            Padding(
                                              padding: const EdgeInsets.symmetric(
                                                  horizontal: 4.0),
                                              child: IconButton(
                                                  tooltip: "Miscellaneous",
                                                  icon: Icon(
                                                    Icons.dashboard_outlined,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pushNamed(context, "/misc");
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 20,),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.max,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Registration ID",
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme.headline1
                                                      .copyWith(
                                                          fontSize: Scaler
                                                              .scaleWidgetWidth(
                                                                  16,
                                                                  widthFactor),
                                                          fontFamily: medium),
                                                ),
                                                Text(
                                                  snapshot.data.registration,
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme.headline3
                                                      .copyWith(
                                                          fontSize: Scaler
                                                              .scaleWidgetWidth(
                                                                  20,
                                                                  widthFactor),
                                                          fontFamily: medium),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 20,
                                              width: 1,
                                              color: theme
                                                  .textTheme.headline3.color
                                                  .withOpacity(0.45),
                                            ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Semester",
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme.headline1
                                                      .copyWith(
                                                          fontSize: Scaler
                                                              .scaleWidgetWidth(
                                                                  16,
                                                                  widthFactor),
                                                          fontFamily: medium),
                                                ),
                                                Text(
                                                  snapshot
                                                      .data
                                                      .attendance[index + 1]
                                                      .semester,
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme.headline3
                                                      .copyWith(
                                                          fontSize: Scaler
                                                              .scaleWidgetWidth(
                                                                  20,
                                                                  widthFactor),
                                                          fontFamily: medium),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              height: 20,
                                              width: 1,
                                              color: theme
                                                  .textTheme.headline3.color
                                                  .withOpacity(0.45),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  "Academic Year",
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme.headline1
                                                      .copyWith(
                                                          fontSize: Scaler
                                                              .scaleWidgetWidth(
                                                                  16,
                                                                  widthFactor),
                                                          fontFamily: medium),
                                                ),
                                                Text(
                                                  snapshot
                                                      .data
                                                      .attendance[index + 1]
                                                      .year,
                                                  textAlign: TextAlign.center,
                                                  style: theme
                                                      .textTheme.headline3
                                                      .copyWith(
                                                          fontSize: Scaler
                                                              .scaleWidgetWidth(
                                                                  20,
                                                                  widthFactor),
                                                          fontFamily: medium),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width -
                                                40,
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisSize: MainAxisSize.max,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      "To refresh attendance, logout and log back in.",
                                                      //"To refresh attendance, logout and log back in.\nClick on a card to see marks and more info.",
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                          fontSize: Scaler
                                                              .scaleWidgetWidth(
                                                                  12,
                                                                  widthFactor)),
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                    ],
                                  ),
                                );
                              } else if (index ==
                                  snapshot.data.attendance.length - 1) {
                                return Padding(
                                  padding: EdgeInsets.only(
                                    bottom: Scaler.scaleWidgetHeight(
                                        130, heightFactor),
                                  ),
                                  child: AttendanceCard(
                                    subject: _formatSubject(snapshot
                                        .data.attendance[index].subject),
                                    code: snapshot
                                        .data.attendance[index].subjectCode,
                                    classesAbsent: snapshot
                                        .data.attendance[index].daysAbsent,
                                    classesPresent: snapshot
                                        .data.attendance[index].daysPresent,
                                    attendancePercentage: snapshot.data
                                        .attendance[index].attendancePercentage,
                                    totalClasses: snapshot
                                        .data.attendance[index].totalClass,
                                    index: index,
                                    onTap: () {

                                    },
                                  ),
                                );
                              } else {
                                return AttendanceCard(
                                  subject: _formatSubject(
                                      snapshot.data.attendance[index].subject),
                                  code: snapshot
                                      .data.attendance[index].subjectCode,
                                  classesAbsent: snapshot
                                      .data.attendance[index].daysAbsent,
                                  classesPresent: snapshot
                                      .data.attendance[index].daysPresent,
                                  attendancePercentage: snapshot.data
                                      .attendance[index].attendancePercentage,
                                  totalClasses: snapshot
                                      .data.attendance[index].totalClass,
                                  index: index,
                                  onTap: () {

                                  },
                                );
                              }
                            },
                          );
                        }
                      }
                    } else if (snapshot.hasError) {
                      return timeout
                          ? Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width * 0.65,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Image.asset(
                                      "assets/images/cat-02.png",
                                      height: 200,
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    Text(
                                      "Cannot fetch your SLCM data",
                                      textAlign: TextAlign.center,
                                      style: theme.textTheme.headline3,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Could not connect to the internet. Please check your connection and try again.",
                                      textAlign: TextAlign.center,
                                    ),
                                    Align(
                                      alignment: Alignment.center,
                                      child: MaterialButton(
                                        onPressed: () {
                                          setState(() {
                                            timeout = false;
                                            oldCaptcha = true;
                                            _textCap.clear();
                                            setLoggedInState(false);
                                          });
                                        },
                                        minWidth: 30,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.refresh),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text("Retry"),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Center(
                              child: Container(
                                height: 200,
                                width: 400,
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Image.asset(
                                      "assets/images/small-cat.gif",
                                      width: 150,
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      "Parsing your attendance data...",
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            );
                    } else {
                      return Center(
                        child: Container(
                          height: 200,
                          width: 400,
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Image.asset(
                                "assets/images/small-cat.gif",
                                width: 150,
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                "Parsing your attendance data...",
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  }),
        ),
      ),
    );
  }

  showConfirmDialog(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;

    Widget okButton = FlatButton(
      child: Text(
        "OK",
        style: theme.textTheme.bodyText1,
      ),
      onPressed: () {
        setState(() {
          isLoggedIn = false;
        });
        Navigator.pop(context);
      },
    );

    Widget cancelButton = FlatButton(
      child: Text(
        "Cancel",
        style: theme.textTheme.bodyText1,
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );

    AlertDialog alert = AlertDialog(
      title: Text(
        "Refreshing Attendance",
        style: theme.textTheme.headline3.copyWith(
          fontSize: 20,
        ),
      ),
      content: Wrap(
        children: [
          Column(
            children: [
              Text(
                refreshAlert,
                style: theme.textTheme.bodyText1.copyWith(
                  fontSize: 16,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(
                height: Scaler.scaleWidgetHeight(20, heightFactor),
              ),
            ],
          ),
        ],
      ),
      actions: [
        okButton,
        cancelButton,
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

String _capitalise(String name) {
  final splitName = name.split(" ");

  if (splitName.length == 1) {
    return '${splitName[0][0]}${splitName[0].substring(1).toLowerCase()}';
  }

  return '${splitName[0][0]}${splitName[0].substring(1).toLowerCase()}\n${splitName.last[0]}${splitName.last.substring(1).toLowerCase()}';
}

List<String> ROMANS = [
  'I',
  'II',
  'III',
  'IV',
  'V',
  'VI',
  'VII',
  'VIII',
  'IX',
  'X'
];

String _formatSubject(String subject) {
  final splitName = subject.split(" ");
  String returnName = "";
  for (int i = 0; i < splitName.length; i++) {
    if (ROMANS.contains(splitName[i])) {
      returnName = returnName + " " + splitName[i];
      break;
    }
    if (splitName[i] != 'OF' && splitName[i] != 'AND') {
      returnName = returnName +
          " " +
          splitName[i][0] +
          splitName[i].substring(1).toLowerCase();
    } else {
      returnName = returnName + " " + splitName[i].toLowerCase();
    }
  }
  return returnName.trim();
}

int _validateRegistrationNumber(String registration) {
  if (registration.isEmpty) {
    //Code 0: Null string received
    return 0;
  }
  if (registration.length != 9) {
    //Code 1: Invalid Registration Number - Not 9 digit
    return 1;
  }
  if (registration.contains(RegExp(r'^[0-9]*\$'))) {
    //Code 2: Invalid Registration Number - Contains chars other than numbers
    return 2;
  } else {
    return -1;
  }
}

String parseValidationErrors(int errorCode) {
  switch (errorCode) {
    case 0:
      return "Please enter your MIT registration number";
    case 1:
      return "Please enter a valid registration number";
    case 2:
      return "Please enter a valid registration number";
    case -1:
      return null;
    default:
      return null;
  }
}
