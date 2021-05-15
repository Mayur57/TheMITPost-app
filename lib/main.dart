import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mit_post/src/flutter_display_mode.dart';
import 'package:mit_post/src/model/display_mode.dart';
import 'package:mit_post/screens/aboutUsPage.dart';
import 'package:mit_post/screens/noticesPage.dart';
import 'package:mit_post/screens/privacyPolicy.dart';
import 'package:mit_post/screens/rootPage.dart';
import 'package:mit_post/util/routes.dart';
import 'package:mit_post/util/shortcuts.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/strings.dart';
import 'package:mit_post/util/themes.dart';
import 'package:provider/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:quick_actions/quick_actions.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  GestureBinding.instance.resamplingEnabled = true; /// Touch rate sampling flag
  runApp(
    ChangeNotifierProvider<AppThemeStateNotifier>(
      builder: (context) => AppThemeStateNotifier(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final quickActions = QuickActions();
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey(debugLabel: "Main Navigator");

  @override
  void initState() {
    super.initState();
    setOptimalDisplayMode();
    preCacheAssetImages();
    final fbm = FirebaseMessaging();
    fbm.subscribeToTopic('notice');
    fbm.subscribeToTopic('test');
    fbm.subscribeToTopic('update');
    fbm.configure(
      onMessage: (Map<String, dynamic> message) async {
        if(message['from'] == '/topics/notice'){
          navigatorKey.currentState.push(
            MaterialPageRoute(builder: (_) => RootPage(selectedPageIndex: 4)),
          );
        }
        else if(message['from'] == '/topics/update'){
          launch('https://play.google.com/store/apps/details?id=com.thepost.app');
        }
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (_) => RootPage(selectedPageIndex: 4)),
        );
        // Navigator.of(context).pushNamed(message['screen']);
        print("onMessage: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        navigatorKey.currentState.push(
            MaterialPageRoute(builder: (_) => RootPage(selectedPageIndex: 4)),
        );
        // Navigator.of(context).pushNamed(message['screen']);
        print("onMessage: $message");
      },
    );
    initAppShortcuts();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> setOptimalDisplayMode() async {
    final List<DisplayMode> supported = await FlutterDisplayMode.supported;
    final DisplayMode active = await FlutterDisplayMode.active;

    final List<DisplayMode> sameResolution = supported.where(
            (DisplayMode m) => m.width == active.width
            && m.height == active.height).toList()..sort(
            (DisplayMode a, DisplayMode b) =>
            b.refreshRate.compareTo(a.refreshRate));

    final DisplayMode mostOptimalMode = sameResolution.isNotEmpty
        ? sameResolution.first
        : active;

    await FlutterDisplayMode.setHighRefreshRate();
  }

  void initAppShortcuts() {
    quickActions.initialize((type) {
      String route = "/" + type;
      if(route == '/notice'){
        navigatorKey.currentState.push(
          MaterialPageRoute(builder: (_) => RootPage(selectedPageIndex: 4)),
        );
      }
      else if(route == '/slcm'){
        navigatorKey.currentState.push(
          MaterialPageRoute(builder: (_) => RootPage(selectedPageIndex: 2)),
        );
      }
    });

    quickActions.setShortcutItems(<ShortcutItem>[
      ShortcutItem(type: "notice", localizedTitle: "Notices", icon: "icon_notice"),
      ShortcutItem(type: "slcm", localizedTitle: "SLCM", icon: "icon_slcm",),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppThemeStateNotifier>(
      builder: (context, state, child) {
        return Scalable(
          rootWidget: MaterialApp(
            navigatorKey: navigatorKey,
            title: 'The MIT Post',
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: state.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            initialRoute: '/',
            onGenerateRoute: RouteGenerator.generateRoute,
            debugShowCheckedModeBanner: false,

            /// Uncomment for performance profiling
            // showPerformanceOverlay: true,
          ),
          context: context,
          printDebugFlag: false,
        );
      },
    );
  }

  void preCacheAssetImages() {
    precacheImage(Image.asset(p1).image, context);
    precacheImage(Image.asset(p2).image, context);
    precacheImage(Image.asset(p3).image, context);
    precacheImage(Image.asset(p4).image, context);
    precacheImage(Image.asset(p5).image, context);
    precacheImage(Image.asset(p6).image, context);
    precacheImage(Image.asset(p7).image, context);
    precacheImage(Image.asset(p8).image, context);
    precacheImage(Image.asset('assets/images/headers-02.png').image, context);
    precacheImage(Image.asset('assets/images/headers-01.png').image, context);
  }
}