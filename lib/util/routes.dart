import 'package:flutter/material.dart';
import 'package:mit_post/screens/aboutUsPage.dart';
import 'package:mit_post/screens/changelogScreen.dart';
import 'package:mit_post/screens/developerPage.dart';
import 'package:mit_post/screens/extrasPage.dart';
import 'package:mit_post/screens/introPage.dart';
import 'package:mit_post/screens/magazinePage.dart';
import 'package:mit_post/screens/noticesPage.dart';
import 'package:mit_post/screens/privacyPolicy.dart';
import 'package:mit_post/screens/rootPage.dart';
import 'package:mit_post/screens/switcherUtilityPage.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => SwitcherUtilityPage());
      case '/dev':
        return MaterialPageRoute(builder: (_) => DeveloperPage());
      case '/mag':
        return MaterialPageRoute(builder: (_) => MagazinePage());
      case '/root':
        return MaterialPageRoute(builder: (_) => RootPage());
      case '/intro':
        return MaterialPageRoute(builder: (_) => IntroPage());
      case '/misc':
        return MaterialPageRoute(builder: (_) => ExtrasPage());
      case '/changelog':
        return MaterialPageRoute(builder: (_) => ChangelogScreen());
      case '/about':
        return MaterialPageRoute(builder: (_) => AboutUsPage());
      case '/priv':
        return MaterialPageRoute(builder: (_) => PrivacyPolicyPage());
      case '/notice':
        return MaterialPageRoute(builder: (_) => NoticesPage());
      case '/notif':
        return MaterialPageRoute(builder: (_) => RootPage(selectedPageIndex: 2));
      case '/slcm':
        return MaterialPageRoute(builder: (_) => RootPage(selectedPageIndex: 2));
      default:
        return MaterialPageRoute(builder: (_) => SwitcherUtilityPage());
    }
  }
}
