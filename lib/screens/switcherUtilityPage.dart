import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:mit_post/screens/introPage.dart';
import 'package:mit_post/screens/rootPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

///  The way this works is that this page widget routes to different
///  possible pages after checking a boolean flag.
///
/// The boolean flag, [seen], is stored locally as a key-value pair and is
/// retrieved every time the app is called.
///
/// [seen] is initialised to [false] by default and is set to true if
/// the app is opened for the first time. If the flag value is true
/// the app displays home screen otherwise the page to be shown on
/// the first start is shown.

class SwitcherUtilityPage extends StatefulWidget {
  @override
  SwitcherUtilityPageState createState() => new SwitcherUtilityPageState();
}

class SwitcherUtilityPageState extends State<SwitcherUtilityPage>
    with AfterLayoutMixin<SwitcherUtilityPage> {
  Future checkFirstSeen() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool _seen = (prefs.getBool('seen') ?? false);

    if (_seen) {
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new RootPage()));
    } else {
      await prefs.setBool('seen', true);
      Navigator.of(context).pushReplacement(
          new MaterialPageRoute(builder: (context) => new IntroPage()));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF17181C),
      body: Center(),
    );
  }
}
