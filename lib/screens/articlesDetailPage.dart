import 'dart:async';
import 'dart:ui';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:html/parser.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/strings.dart';
import 'package:mit_post/util/themes.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';
import 'dart:async';
import '../models/DetailedArticle.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:dynamic_scaler/dynamic_scaler.dart';

class ArticleDetailPage extends StatefulWidget {
  final int id;
  final String link;
  final String title;
  final String author;

  const ArticleDetailPage({this.id, this.title, this.author, this.link});

  @override
  _ArticleDetailPageState createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  Future<DetailedArticle> html;
  double _articleFontSize = 14;
  String _articleFontFamily = regular;
  bool _deviceVibrationCapabilities = true;
  double heightFactor = 8.94;
  double widthFactor = 4.31;
  static double sigmaValue = 10.0;

  Timer _timer;
  bool timeout = false;

  @override
  void initState() {
    super.initState();
    html = fetchDetailedArticles(widget.id);
    _timeout();
  }

  _timeout() {
    _timer = new Timer(const Duration(seconds: 5), () {
      setState(() {
        timeout = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    bool shouldVibrate = Provider.of<AppThemeStateNotifier>(context).isVibrationAllowed;

    return SafeArea(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            Share.share("Check out this article by The MIT Post: \n" +
                _formatHTML(widget.title) +
                "; written by " +
                _formatHTML(widget.author) +
                ".\n\n" +
                widget.link);
          },
          label: Text(
            "Share",
            style: theme.textTheme.bodyText1.copyWith(
              fontSize: 16,
              color: Colors.white,
            ),
          ),
          icon: Icon(
            Icons.share,
            size: 16,
            color: Colors.white,
          ),
          backgroundColor: AppTheme.mitPostOrange,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        bottomNavigationBar: BottomAppBar(
          color: theme.scaffoldBackgroundColor,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 0, 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                IconButton(
                  tooltip: "Change font",
                  icon: Icon(Icons.format_color_text),
                  onPressed: () {
                    _changeFontFamily();
                    shouldVibrate
                        ? Vibrate.feedback(FeedbackType.heavy)
                        : null;
                  },
                ), //change font
                IconButton(
                  tooltip: "Increase font size",
                  icon: Icon(Icons.keyboard_arrow_up),
                  onPressed: () {
                    _incrementFontSize();
                    shouldVibrate
                        ? Vibrate.feedback(FeedbackType.heavy)
                        : null;
                  },
                ), //Increase font size
                IconButton(
                  tooltip: "Decrease font size",
                  icon: Icon(Icons.keyboard_arrow_down),
                  onPressed: () {
                    _decrementFontSize();
                    shouldVibrate
                        ? Vibrate.feedback(FeedbackType.heavy)
                        : null;
                  },
                ), //Decrease font size
                IconButton(
                  tooltip: "Toggle dark mode",
                  icon: Icon(Icons.lightbulb_outline),
                  onPressed: () {
                    _changeTheme(darkMode, shouldVibrate);
                  },
                ), //toggle dark mode
              ],
            ),
          ),
        ),
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: FutureBuilder<DetailedArticle>(
                future: html,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Column(
                      children: [
                        Image.network(
                          snapshot.data.imageUrl,
                          fit: BoxFit.fitWidth,
                          height: 200,
                          width: 500,
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            _formatHTML(snapshot.data.title),
                            style: theme.textTheme.headline3
                                .copyWith(fontFamily: bold),
                            textAlign: TextAlign.left,
                          ),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: Text(
                                  _formatHTML(snapshot.data.author),
                                  style: theme.textTheme.bodyText1.copyWith(
                                    color: theme.textTheme.bodyText1.color.withOpacity(0.5),
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              Text(
                                '${snapshot.data.day} ${snapshot.data.month}, ${snapshot.data.year}',
                                style: theme.textTheme.bodyText1.copyWith(
                                  color: theme.textTheme.bodyText1.color.withOpacity(0.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Html(
                            data: snapshot.data.description,
                            onLinkTap: (url) async {
                              if (await canLaunch(url)) {
                                await launch(url);
                              } else {
                                throw 'Could not launch $url';
                              }
                            },
                            style: {
                              "body": Style(
                                fontSize: FontSize(_articleFontSize),
                                fontFamily: _articleFontFamily,
                                textAlign: TextAlign.left,
                                color: darkMode ? Colors.white : Colors.black,
                              ),
                              "h1":
                                  Style(fontSize: FontSize(_articleFontSize + 4), textAlign: TextAlign.left,),
                              "h2":
                                  Style(fontSize: FontSize(_articleFontSize + 4), textAlign: TextAlign.left,),
                              "h3":
                                  Style(fontSize: FontSize(_articleFontSize + 4), textAlign: TextAlign.left,),
                              "h4":
                                  Style(fontSize: FontSize(_articleFontSize + 4), textAlign: TextAlign.left,),
                              "h5":
                                  Style(fontSize: FontSize(_articleFontSize + 4), textAlign: TextAlign.left,),
                              "h6":
                                  Style(fontSize: FontSize(_articleFontSize + 4), textAlign: TextAlign.left,),
                            },
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return timeout
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/images/cat-01.png",
                                  height: 200,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Cannot fetch the article",
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.headline3,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Container(
                                  width:
                                      Scaler.scaleWidgetWidth(300, widthFactor),
                                  child: Text(
                                    "Could not connect to the internet. Please check your connection and try again.",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.center,
                                  child: MaterialButton(
                                    onPressed: () {
                                      setState(() {
                                        timeout = false;
                                        html = fetchDetailedArticles(widget.id);
                                        _timeout();
                                      });
                                    },
                                    minWidth: 30,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
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
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    AppTheme.mitPostOrange),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text("Just a second...")
                            ],
                          );
                  }
                  return !timeout
                      ? Center(child: CircularProgressIndicator())
                      : Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  _incrementFontSize() {
    if (_articleFontSize < 22) {
      setState(() {
        _articleFontSize += 2.0;
      });
      print("Font size: " + _articleFontSize.toString());
    } else {
      Fluttertoast.showToast(
        msg: "This is the maximum font size!",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  _decrementFontSize() {
    if (_articleFontSize > 12) {
      setState(() {
        _articleFontSize -= 2.0;
      });
      print("Font size: " + _articleFontSize.toString());
    } else {
      Fluttertoast.showToast(
        msg: "This is the minimum font size!",
        gravity: ToastGravity.CENTER,
        toastLength: Toast.LENGTH_SHORT,
      );
    }
  }

  _changeFontFamily() {
    if (_articleFontFamily == serif) {
      setState(() {
        _articleFontFamily = regular;
      });
    } else if (_articleFontFamily == regular) {
      setState(() {
        _articleFontFamily = serif;
      });
    }
  }

  _formatConcatHTML(String html) {
    return html.length > 30
        ? parse(parse(html).body.text).documentElement.text.substring(0, 30) +
            "..."
        : parse(parse(html).body.text).documentElement.text;
  }

  _formatHTML(String html) {
    return parse(parse(html).body.text).documentElement.text;
  }

  _changeTheme(bool darkMode, bool shouldVibrate) {
    if (!darkMode) {
      FlutterStatusbarcolor.setNavigationBarColor(Color(0xFF17181C));
      FlutterStatusbarcolor.setStatusBarColor(Color(0xFF17181C));
    } else {
      FlutterStatusbarcolor.setNavigationBarColor(Color(0xFFFFFFFF));
      FlutterStatusbarcolor.setStatusBarColor(Color(0xFFFFFFFF));
    }
    FlutterStatusbarcolor.setStatusBarWhiteForeground(!darkMode);
    FlutterStatusbarcolor.setNavigationBarWhiteForeground(!darkMode);
    shouldVibrate ? Vibrate.feedback(FeedbackType.heavy) : null;
    bool boolean = darkMode ? false : true;
    Provider.of<AppThemeStateNotifier>(context).updateTheme(boolean);
  }
}
