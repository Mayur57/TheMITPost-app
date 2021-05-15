import 'dart:async';
import 'dart:ui';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:mit_post/models/Articles.dart';
import 'package:mit_post/util/themes.dart';
import 'package:mit_post/widgets/appBar.dart';
import 'package:mit_post/widgets/articleCard.dart';
import 'package:mit_post/widgets/darkModeAppBarIcon.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../util/strings.dart';
import '../models/Events.dart';
import 'package:intl/intl.dart';

class EventsPage extends StatefulWidget {
  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>
    with AutomaticKeepAliveClientMixin<EventsPage> {
  @override
  bool get wantKeepAlive => true;

  Future<List<Event>> futureEvents;
  Future<List<Article>> futureArticles;

  double heightFactor = 8.94;
  double widthFactor = 4.31;
  static double sigmaValue = 10.0;

  Timer _timer;
  bool timeout = false;
  int mainColumnItemOffset = 5;

  @override
  void initState() {
    super.initState();
    futureEvents = fetchEvents();
    futureArticles = fetchArticles();
    _timeout();
  }

  Future<void> _refresh() async {
    print("Refreshing items...");
    setState(() {
      futureEvents = fetchEvents();
      print(futureEvents);
      futureArticles = fetchArticles();
    });
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

    /// Set this to [true] if you want to enable club tiles
    /// This flag will be removed once Clubs implementation is complete
    bool isClubsModeEnabled = false;

    super.build(context);

    return Center(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: RefreshIndicator(
            onRefresh: _refresh,
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: FutureBuilder<List<Article>>(
                future: futureArticles,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data.length == 0
                        ? Center(
                            child: Container(
                              height:
                                  Scaler.scaleWidgetHeight(300, heightFactor),
                              width: MediaQuery.of(context).size.width * 0.6,
                              child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    "assets/images/cat-01.png",
                                    height: 120,
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    "Uh oh, this shouldn't be happening. Please contact our developers.",
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          )
                        : AnimationLimiter(
                            child: ListView.builder(
                              physics: BouncingScrollPhysics(),
                              itemCount:
                                  snapshot.data.length + mainColumnItemOffset,
                              itemBuilder: (BuildContext context, int index) {
                                if (index == 0) {
                                  return Column(
                                    children: [
                                      SizedBox(
                                        height: 40,
                                      ),
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.925,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              events,
                                              style: theme.textTheme.headline1,
                                            ),
                                            // Container(width: 200,),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 4.0),
                                              child: IconButton(
                                                  tooltip: "Miscellaneous",
                                                  icon: Icon(
                                                    Icons.dashboard_outlined,
                                                    color: Colors.grey,
                                                  ),
                                                  onPressed: () {
                                                    Navigator.pushNamed(
                                                        context, "/misc");
                                                  }),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                    ],
                                  );
                                } else if (index == 1) {
                                  return isClubsModeEnabled
                                      ? Padding(
                                          padding: EdgeInsets.only(
                                            top: Scaler.scaleWidgetHeight(
                                                8, heightFactor),
                                            bottom: Scaler.scaleWidgetHeight(
                                                8, heightFactor),
                                          ),
                                          child: ClubsCluster(),
                                        )
                                      : Container();
                                } else if (index == 2) {
                                  return Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: Scaler.scaleWidgetWidth(
                                                16, widthFactor),
                                            right: Scaler.scaleWidgetWidth(
                                                16, widthFactor),
                                            top: Scaler.scaleWidgetHeight(
                                                16, heightFactor),
                                            bottom: Scaler.scaleWidgetHeight(
                                                8, heightFactor),
                                          ),
                                          child: Text(
                                            "Upcoming Events",
                                            style: theme.textTheme.headline3.copyWith(
                                              fontSize: Scaler.scaleWidgetWidth(
                                                  24, widthFactor),
                                            ),
                                          ),
                                        ),
                                      ),                            Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(16, 4, 8, 16),
                                          child: Container(
                                            color: AppTheme.mitPostOrange,
                                            height: 1.5,
                                            width: 50,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else if (index == 3) {
                                  return Container(
                                    height: Scaler.scaleWidgetHeight(
                                        270, heightFactor),
                                    child: FutureBuilder<List<Event>>(
                                      future: futureEvents,
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          return snapshot.data.length == 0
                                              ? Center(
                                                  child: Container(
                                                    height: Scaler
                                                        .scaleWidgetHeight(
                                                            270, heightFactor),
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.6,
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        //height 120
                                                        Image.asset(
                                                          "assets/images/cat-02.png",
                                                          height: 150,
                                                        ),
                                                        SizedBox(
                                                          height: 10,
                                                        ),
                                                        Text(
                                                          "There are no upcoming events.\nCheck again soon!",
                                                          textAlign:
                                                              TextAlign.center,
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                )
                                              : ListView.builder(
                                                  physics:
                                                      BouncingScrollPhysics(),
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  itemCount:
                                                      snapshot.data.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                          int index) {
                                                    return isEventExpired(
                                                            timestampParser(
                                                                snapshot
                                                                    .data[index]
                                                                    .endDate),
                                                            nowEpoch())
                                                        ? GestureDetector(
                                                            onTap: () {
                                                              FlutterStatusbarcolor
                                                                  .setStatusBarColor(
                                                                      Colors
                                                                          .transparent);
                                                              Navigator.of(context).push(
                                                                  PageRouteBuilder(
                                                                      opaque:
                                                                          false,
                                                                      pageBuilder:
                                                                          (BuildContext context,
                                                                              _,
                                                                              __) {
                                                                        return BackdropFilter(
                                                                          filter: ImageFilter.blur(
                                                                              sigmaY: sigmaValue,
                                                                              sigmaX: sigmaValue),
                                                                          child:
                                                                              Container(
                                                                            height:
                                                                                MediaQuery.of(context).size.height,
                                                                            width:
                                                                                MediaQuery.of(context).size.width,
                                                                            decoration:
                                                                                BoxDecoration(
                                                                              color: Colors.black.withOpacity(0.5),
                                                                            ),
                                                                            child:
                                                                                Center(
                                                                              child: SingleChildScrollView(
                                                                                physics: BouncingScrollPhysics(),
                                                                                child: Column(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: <Widget>[
                                                                                    SizedBox(
                                                                                      height: Scaler.scaleWidgetHeight(150, heightFactor),
                                                                                    ),
                                                                                    Container(
                                                                                      width: Scaler.scaleWidgetWidth(MediaQuery.of(context).size.width, widthFactor) - Scaler.scaleWidgetWidth(80, widthFactor),
                                                                                      child: Text(
                                                                                        "Event starts on: " + snapshot.data[index].startDate,
                                                                                        style: theme.textTheme.bodyText1.copyWith(color: theme.colorScheme.primary, fontSize: 16),
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      width: Scaler.scaleWidgetWidth(MediaQuery.of(context).size.width, widthFactor) - Scaler.scaleWidgetWidth(80, widthFactor),
                                                                                      child: Text(
                                                                                        "Event ends on: " + snapshot.data[index].endDate,
                                                                                        style: theme.textTheme.bodyText1.copyWith(color: theme.colorScheme.primary, fontSize: 16),
                                                                                      ),
                                                                                    ),
                                                                                    Hero(
                                                                                      tag: 'Event$index',
                                                                                      child: Container(
                                                                                        width: Scaler.scaleWidgetWidth(MediaQuery.of(context).size.width, widthFactor) - Scaler.scaleWidgetWidth(50, widthFactor),
                                                                                        child: Card(
                                                                                          color: Colors.transparent,
                                                                                          semanticContainer: true,
                                                                                          clipBehavior: Clip.antiAliasWithSaveLayer,
                                                                                          child: FadeInImage.memoryNetwork(
                                                                                            placeholder: kTransparentImage,
                                                                                            image: snapshot.data[index].imageUrl,
                                                                                          ),
                                                                                          shape: RoundedRectangleBorder(
                                                                                            borderRadius: BorderRadius.circular(10.0),
                                                                                          ),
                                                                                          elevation: 5,
                                                                                          margin: EdgeInsets.all(10),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: Scaler.scaleWidgetHeight(10, heightFactor),
                                                                                    ),
                                                                                    Container(
                                                                                      width: Scaler.scaleWidgetWidth(MediaQuery.of(context).size.width, widthFactor) - Scaler.scaleWidgetWidth(80, widthFactor),
                                                                                      child: Text(
                                                                                        snapshot.data[index].name,
                                                                                        style: theme.textTheme.bodyText1.copyWith(
                                                                                          color: theme.colorScheme.primary,
                                                                                          fontSize: Scaler.scaleWidgetWidth(16, widthFactor),
                                                                                        ),
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: Scaler.scaleWidgetHeight(
                                                                                        20,
                                                                                        heightFactor,
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      width: Scaler.scaleWidgetWidth(MediaQuery.of(context).size.width, widthFactor) - Scaler.scaleWidgetWidth(80, widthFactor),
                                                                                      child: Text(
                                                                                        // utf8convert(snapshot.data[index].description),
                                                                                        snapshot.data[index].description,
                                                                                        style: theme.textTheme.bodyText1.copyWith(
                                                                                          color: theme.colorScheme.primary,
                                                                                          fontSize: Scaler.scaleWidgetWidth(16, widthFactor),
                                                                                        ),
                                                                                        textAlign: TextAlign.start,
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: Scaler.scaleWidgetHeight(
                                                                                        20,
                                                                                        heightFactor,
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      width: Scaler.scaleWidgetWidth(MediaQuery.of(context).size.width, widthFactor) - Scaler.scaleWidgetWidth(80, widthFactor),
                                                                                      child: MaterialButton(
                                                                                        height: Scaler.scaleWidgetHeight(50, heightFactor),
                                                                                        color: Colors.blueAccent.withOpacity(0.15),
                                                                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0), side: BorderSide(color: Colors.blueAccent.withOpacity(0.5), width: 1)),
                                                                                        onPressed: () async {
                                                                                          String url = snapshot.data[index].registrationLink;
                                                                                          if (await canLaunch(url)) {
                                                                                            await launch(url);
                                                                                          } else {
                                                                                            throw 'Could not launch $url';
                                                                                          }
                                                                                        },
                                                                                        child: Text(
                                                                                          "REGISTER FOR EVENT",
                                                                                          style: TextStyle(fontSize: Scaler.scaleWidgetWidth(14, widthFactor), fontFamily: medium, color: theme.colorScheme.primary.withOpacity(0.65), letterSpacing: 1.35),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    SizedBox(
                                                                                      height: Scaler.scaleWidgetHeight(200, heightFactor),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                        );
                                                                      }));
                                                            },
                                                            child: Hero(
                                                              tag:
                                                                  'Event$index',
                                                              child: Container(
                                                                height: Scaler
                                                                    .scaleWidgetHeight(
                                                                        270,
                                                                        heightFactor),
                                                                width: Scaler
                                                                    .scaleWidgetWidth(
                                                                        235,
                                                                        widthFactor),
                                                                child: Column(
                                                                  children: [
                                                                    Container(
                                                                      height: Scaler.scaleWidgetHeight(
                                                                          270,
                                                                          heightFactor),
                                                                      width: Scaler.scaleWidgetWidth(
                                                                          235,
                                                                          widthFactor),
                                                                      child:
                                                                          Card(
                                                                        semanticContainer:
                                                                            true,
                                                                        clipBehavior:
                                                                            Clip.antiAliasWithSaveLayer,
                                                                        child: FadeInImage
                                                                            .memoryNetwork(
                                                                          placeholder:
                                                                              kTransparentImage,
                                                                          image: snapshot
                                                                              .data[index]
                                                                              .imageUrl,
                                                                          width: Scaler.scaleWidgetWidth(
                                                                              225,
                                                                              widthFactor),
                                                                          fit: BoxFit
                                                                              .cover,
                                                                        ),
                                                                        shape:
                                                                            RoundedRectangleBorder(
                                                                          borderRadius:
                                                                              BorderRadius.circular(10.0),
                                                                        ),
                                                                        elevation:
                                                                            5,
                                                                        margin: EdgeInsets.symmetric(
                                                                            vertical:
                                                                                10,
                                                                            horizontal:
                                                                                5),
                                                                      ),
                                                                    ),
                                                                    Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .center,
                                                                      child:
                                                                          Container(
                                                                        width: Scaler.scaleWidgetWidth(
                                                                            220,
                                                                            widthFactor),
                                                                        child:
                                                                            Text(
                                                                          snapshot
                                                                              .data[index]
                                                                              .name,
                                                                          textAlign:
                                                                              TextAlign.center,
                                                                          style: theme
                                                                              .textTheme
                                                                              .bodyText2,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        : Container();
                                                  },
                                                );
                                        } else if (snapshot.hasError) {
                                          return Center(
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.65,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Icon(
                                                    FontAwesomeIcons
                                                        .exclamationTriangle,
                                                    size: 40,
                                                    color: theme.colorScheme
                                                        .primaryVariant
                                                        .withOpacity(0.7),
                                                  ),
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Text(
                                                    "Error loading events. Events Portal by The Student Council might be facing issues at the moment. Try again later.",
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }
                                        return Center(
                                            child: CircularProgressIndicator());
                                      },
                                    ),
                                  );
                                } else if (index == 4) {
                                  return Column(
                                    children: [
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: EdgeInsets.only(
                                            left: Scaler.scaleWidgetWidth(
                                                16, widthFactor),
                                            right: Scaler.scaleWidgetWidth(
                                                16, widthFactor),
                                            top: Scaler.scaleWidgetHeight(
                                                16, heightFactor),
                                            bottom: Scaler.scaleWidgetHeight(
                                                8, heightFactor),
                                          ),
                                          child: Text(
                                            "Event Reports",
                                            style: theme.textTheme.headline3.copyWith(
                                              fontSize: Scaler.scaleWidgetWidth(
                                                  24, widthFactor),
                                            ),
                                          ),
                                        ),
                                      ),                            Align(
                                        alignment: Alignment.centerLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.fromLTRB(16, 4, 8, 16),
                                          child: Container(
                                            color: AppTheme.mitPostOrange,
                                            height: 1.5,
                                            width: 50,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                } else {
                                  return snapshot.data[index - 5].category ==
                                          "Event Reports"
                                      ? AnimationConfiguration.staggeredList(
                                          position: index,
                                          duration:
                                              const Duration(milliseconds: 400),
                                          child: SlideAnimation(
                                            verticalOffset: 50.0,
                                            child: FadeInAnimation(
                                              child: ArticleCard(
                                                theme: theme,
                                                id: snapshot.data[index - 4].id,
                                                title: snapshot
                                                    .data[index - 5].title,
                                                author: snapshot
                                                    .data[index - 5].author,
                                                imageUrl: snapshot
                                                    .data[index - 5].imageUrl,
                                                description: snapshot
                                                    .data[index - 5]
                                                    .description,
                                                link: snapshot
                                                    .data[index - 5].link,
                                                date: snapshot
                                                        .data[index - 5].day +
                                                    ' ' +
                                                    snapshot
                                                        .data[index - 5].month +
                                                    ' ' +
                                                    snapshot
                                                        .data[index - 5].year,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Container();
                                }
                              },
                            ),
                          );
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
                                    "Cannot fetch events",
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
                                          futureEvents = fetchEvents();
                                          futureArticles = fetchArticles();
                                          _timeout();
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
                  return Column(
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
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// TODO (Mayur57 03:32 11-01-2021) -> Club and Stuff Tiles
  /// Targeted release version: 3.1.0
  /// Resource(s) used: NONE
  // ignore: non_constant_identifier_names
  Widget ClubsCluster() {
    double kCategoryTitleFontSize = 14.0;
    ShapeBorder shapeBorder = RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(8.0),
      ),
    );
    return Column(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 65,
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Card(
              margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
              shape: shapeBorder,
              color: Theme.of(context).cardColor,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 65,
                child: Center(
                  child: Text(
                    "Official Student Bodies",
                    style: Theme.of(context).textTheme.headline3.copyWith(
                          fontFamily: medium,
                          fontSize: Scaler.scaleWidgetWidth(
                              kCategoryTitleFontSize, widthFactor),
                        ),
                  ),
                ),
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 65,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Card(
                  margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                  shape: shapeBorder,
                  color: Theme.of(context).cardColor,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 65,
                    child: Center(
                      child: Text(
                        "Cultural Clubs",
                        style: Theme.of(context).textTheme.headline3.copyWith(
                              fontFamily: medium,
                              fontSize: Scaler.scaleWidgetWidth(
                                  kCategoryTitleFontSize, widthFactor),
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Card(
                  margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                  shape: shapeBorder,
                  color: Theme.of(context).cardColor,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 65,
                    child: Center(
                      child: Text(
                        "Sports Clubs",
                        style: Theme.of(context).textTheme.headline3.copyWith(
                              fontFamily: medium,
                              fontSize: Scaler.scaleWidgetWidth(
                                  kCategoryTitleFontSize, widthFactor),
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: 65,
          child: Row(
            children: [
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Card(
                  margin: EdgeInsets.fromLTRB(10, 5, 5, 5),
                  shape: shapeBorder,
                  color: Theme.of(context).cardColor,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 65,
                    child: Center(
                      child: Text(
                        "Student Projects",
                        style: Theme.of(context).textTheme.headline3.copyWith(
                              fontFamily: medium,
                              fontSize: Scaler.scaleWidgetWidth(
                                  kCategoryTitleFontSize, widthFactor),
                            ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                child: Card(
                  margin: EdgeInsets.fromLTRB(5, 5, 10, 5),
                  shape: shapeBorder,
                  color: Theme.of(context).cardColor,
                  child: Container(
                    width: MediaQuery.of(context).size.width / 2,
                    height: 65,
                    child: Center(
                      child: Text(
                        "Technical Clubs",
                        style: Theme.of(context).textTheme.headline3.copyWith(
                              fontFamily: medium,
                              fontSize: Scaler.scaleWidgetWidth(
                                  kCategoryTitleFontSize, widthFactor),
                            ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

String truncateCaption(String caption) {
  return caption.length > 240
      ? caption.substring(0, 240).trim() + "..."
      : caption;
}

String utf8convert(String text) {
  List<int> bytes = text.toString().codeUnits;
  return utf8.decode(bytes);
}

int timestampParser(String text) {
  if (text != null) {
    List<String> hold = text.split('-');
    String y = "";
    for (String x in hold) {
      y = y + x;
    }
    int.parse(y);
    nowEpoch();
    return int.parse(y);
  }
  return 0;
}

int nowEpoch() {
  DateTime now = DateTime.now();
  DateFormat format = DateFormat('ddMMyyyy');
  String date = format.format(now);
  // print(date);
  return int.parse(date);
}

bool isEventExpired(int timestamp, int nowEpoch) {
  return timestamp > nowEpoch ? true : false;
}
