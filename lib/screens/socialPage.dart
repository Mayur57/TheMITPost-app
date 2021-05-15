import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mit_post/apiKeys/keys.dart';
import 'package:mit_post/util/themes.dart';
import 'package:mit_post/widgets/contactsCard.dart';
import 'package:mit_post/widgets/darkModeAppBarIcon.dart';
import 'package:mit_post/widgets/tweetCard.dart';
import 'package:transparent_image/transparent_image.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/Instagram.dart';
import '../models/Twitter.dart';
import '../util/strings.dart';
import 'package:twitter_api/twitter_api.dart';
import 'package:dynamic_scaler/dynamic_scaler.dart';
import '../widgets/appBar.dart';

class SocialPage extends StatefulWidget {
  @override
  _SocialPageState createState() => _SocialPageState();
}

class _SocialPageState extends State<SocialPage>
    with AutomaticKeepAliveClientMixin<SocialPage> {
  @override
  bool get wantKeepAlive => true;

  double heightFactor = 8.94;
  double widthFactor = 4.31;

  Timer _timer;
  bool timeout = false;

  static double sigmaValue = 10.0;
  bool shouldShowCanvas = false;
  Future<List<Instagram>> futurePosts;
  Future<List<Twitter>> futureTwitterPosts;

  final _twitterOauth = new twitterApi(
    consumerKey: consumerApiKeyForTwitter,
    consumerSecret: consumerApiSecretForTwitter,
    token: accessTokenForTwitter,
    tokenSecret: accessTokenSecretForTwitter,
  );

  @override
  void initState() {
    super.initState();
    futurePosts = fetchPosts();
    futureTwitterPosts = fetchPostsTwitter(_twitterOauth);
    _timeout();
  }

  Future<void> _refresh() async {
    print("Refreshing items...");
    setState(() {
      futurePosts = fetchPosts();
      futureTwitterPosts = fetchPostsTwitter(_twitterOauth);
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
    super.build(context);

    ThemeData theme = Theme.of(context);
    double kInstagramSectionHeight = 220.0;
    double kPlaylistSectionHeight = 180.0;
    int kSectionPositionOffset = 5;

    /// Set this to [true] if you want to enable the spotify section
    /// This flag will be removed once Spotify implementation is complete
    bool isSpotifySectionEnabled = false;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      // appBar: MyAppBar(title: 'Social Media'),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<List<Twitter>>(
              future: futureTwitterPosts,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    itemCount: snapshot.data.length + kSectionPositionOffset,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.925,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    socialMedia,
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
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              child: ContactCard(),
                              width: MediaQuery.of(context).size.width * 0.95,
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                Scaler.scaleWidgetWidth(16, widthFactor),
                                Scaler.scaleWidgetHeight(8, heightFactor),
                                Scaler.scaleWidgetHeight(8, widthFactor),
                                Scaler.scaleWidgetHeight(4, heightFactor),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        FontAwesomeIcons.instagram,
                                        color: theme.colorScheme.primaryVariant,
                                        size: Scaler.scaleWidgetWidth(
                                            18, widthFactor),
                                      ),
                                      SizedBox(
                                        width: Scaler.scaleWidgetWidth(
                                            10, widthFactor),
                                      ),
                                      Text(
                                        "Instagram Posts",
                                        style:
                                            theme.textTheme.headline3.copyWith(
                                          fontSize: Scaler.scaleWidgetWidth(
                                              18, widthFactor),
                                        ),
                                      ),
                                    ],
                                  ),
                                  MaterialButton(
                                    color: Colors.blueAccent.withOpacity(0.2),
                                    elevation: 0,
                                    height:
                                    Scaler.scaleWidgetHeight(27, heightFactor),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8.0),
                                        side: BorderSide(
                                            color: Colors.blueAccent.withOpacity(0.5), width: 1.5)),
                                    onPressed: () async {
                                      const url = 'https://www.instagram.com/themitpost/';
                                      if (await canLaunch(url)) {
                                        await launch(url);
                                      } else {
                                        throw 'Could not launch $url';
                                      }
                                    },
                                    child: Text(
                                      "FOLLOW",
                                      style: TextStyle(
                                          color: theme.textTheme.headline3.color.withOpacity(0.7),
                                          fontSize: Scaler.scaleWidgetHeight(
                                              11, heightFactor),
                                          letterSpacing: 1.35,
                                          fontFamily: bold),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        );
                      } else if (index == 1) {
                        return Container(
                          height: Scaler.scaleWidgetHeight(
                              kInstagramSectionHeight, heightFactor),
                          child: FutureBuilder<List<Instagram>>(
                            future: futurePosts,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                return snapshot.data.length == 0
                                    ? Center(
                                        child: Container(
                                          height: Scaler.scaleWidgetHeight(
                                              kInstagramSectionHeight,
                                              heightFactor),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.6,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
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
                                    : ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: snapshot.data.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return GestureDetector(
                                            onTap: () {
                                              FlutterStatusbarcolor
                                                  .setStatusBarColor(
                                                      Colors.transparent);
                                              Navigator.of(context).push(
                                                  PageRouteBuilder(
                                                      opaque: false,
                                                      pageBuilder:
                                                          (BuildContext context,
                                                              _, __) {
                                                        return BackdropFilter(
                                                          filter: ImageFilter.blur(
                                                              sigmaY:
                                                                  sigmaValue,
                                                              sigmaX:
                                                                  sigmaValue),
                                                          child: Container(
                                                            height:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .height,
                                                            width:
                                                                MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Colors
                                                                  .black
                                                                  .withOpacity(
                                                                      0.5),
                                                            ),
                                                            child: Center(
                                                              child:
                                                                  SingleChildScrollView(
                                                                physics:
                                                                    BouncingScrollPhysics(),
                                                                child: Column(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    SizedBox(
                                                                      height: Scaler.scaleWidgetHeight(
                                                                          150,
                                                                          heightFactor),
                                                                    ),
                                                                    Hero(
                                                                      tag:
                                                                          index,
                                                                      child:
                                                                          Container(
                                                                        width: MediaQuery.of(context).size.width -
                                                                            50,
                                                                        child:
                                                                            Card(
                                                                          color:
                                                                              Colors.transparent,
                                                                          semanticContainer:
                                                                              true,
                                                                          clipBehavior:
                                                                              Clip.antiAliasWithSaveLayer,
                                                                          child:
                                                                              FadeInImage.memoryNetwork(
                                                                            placeholder:
                                                                                kTransparentImage,
                                                                            image:
                                                                                snapshot.data[index].imageUrl,
                                                                          ),
                                                                          shape:
                                                                              RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                          ),
                                                                          elevation:
                                                                              5,
                                                                          margin:
                                                                              EdgeInsets.all(10),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: Scaler
                                                                          .scaleWidgetHeight(
                                                                              10,
                                                                              heightFactor),
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          80,
                                                                      child:
                                                                          Text(
                                                                        _removeHashtags(snapshot
                                                                            .data[
                                                                                index]
                                                                            .caption
                                                                            .toString()
                                                                            .replaceAll("\\n",
                                                                                "\n")),
                                                                        style: theme
                                                                            .textTheme
                                                                            .bodyText1
                                                                            .copyWith(
                                                                                color: theme.colorScheme.primary,
                                                                                fontSize: Scaler.scaleWidgetWidth(15, widthFactor)),
                                                                        textAlign:
                                                                            TextAlign.start,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: Scaler
                                                                          .scaleWidgetHeight(
                                                                              20,
                                                                              heightFactor),
                                                                    ),
                                                                    Container(
                                                                      width: MediaQuery.of(context)
                                                                              .size
                                                                              .width -
                                                                          80,
                                                                      child:
                                                                          MaterialButton(
                                                                        elevation:
                                                                            0,
                                                                        height: Scaler.scaleWidgetHeight(
                                                                            45,
                                                                            heightFactor),
                                                                        color: Colors
                                                                            .blueAccent
                                                                            .withOpacity(0.15),
                                                                        shape: RoundedRectangleBorder(
                                                                            borderRadius:
                                                                                BorderRadius.circular(10.0),
                                                                            side: BorderSide(color: Colors.blueAccent.withOpacity(0.5), width: 1)),
                                                                        onPressed:
                                                                            () async {
                                                                          String
                                                                              url =
                                                                              snapshot.data[index].link;
                                                                          if (await canLaunch(
                                                                              url)) {
                                                                            await launch(url);
                                                                          } else {
                                                                            throw 'Could not launch $url';
                                                                          }
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "VIEW ON INSTAGRAM",
                                                                          style: TextStyle(
                                                                              fontSize: Scaler.scaleWidgetWidth(14, widthFactor),
                                                                              fontFamily: medium,
                                                                              color: theme.colorScheme.primary.withOpacity(0.65),
                                                                              letterSpacing: 1.35),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: Scaler
                                                                          .scaleWidgetHeight(
                                                                              25,
                                                                              heightFactor),
                                                                    ),
                                                                    Center(
                                                                      child:
                                                                          Text(
                                                                        "POSTED ON: " +
                                                                            snapshot.data[index].date,
                                                                        style: theme.textTheme.bodyText1.copyWith(
                                                                            color: theme.colorScheme.primary.withOpacity(
                                                                                0.45),
                                                                            letterSpacing:
                                                                                1.35,
                                                                            fontSize:
                                                                                13),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: Scaler.scaleWidgetHeight(
                                                                          200,
                                                                          heightFactor),
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
                                              tag: index,
                                              child: Container(
                                                child: Card(
                                                  semanticContainer: true,
                                                  clipBehavior: Clip
                                                      .antiAliasWithSaveLayer,
                                                  child:
                                                      FadeInImage.memoryNetwork(
                                                    placeholder:
                                                        kTransparentImage,
                                                    image: snapshot
                                                        .data[index].imageUrl,
                                                  ),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0),
                                                  ),
                                                  elevation: 5,
                                                  margin: EdgeInsets.all(10),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      );
                              } else if (snapshot.hasError) {
                                return Center(
                                  child: Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Icon(
                                          FontAwesomeIcons.exclamationTriangle,
                                          size: 40,
                                          color: theme
                                              .colorScheme.primaryVariant
                                              .withOpacity(0.7),
                                        ),
                                        SizedBox(
                                          height: 15,
                                        ),
                                        Text(
                                          "An error ocurred :(",
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Center(child: CircularProgressIndicator());
                            },
                          ),
                        );
                      } else if (index == 2) {
                        /// TODO (Mayur57 03:32 11-01-2021) -> Playlists Section
                        /// Targeted release version: 3.1.0
                        /// Resource(s) used: NONE
                        return isSpotifySectionEnabled
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(
                                  Scaler.scaleWidgetWidth(16, widthFactor),
                                  Scaler.scaleWidgetHeight(2, heightFactor),
                                  Scaler.scaleWidgetHeight(8, widthFactor),
                                  Scaler.scaleWidgetHeight(2, heightFactor),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(
                                      children: <Widget>[
                                        Icon(
                                          FontAwesomeIcons.spotify,
                                          color:
                                              theme.colorScheme.primaryVariant,
                                          size: Scaler.scaleWidgetWidth(
                                              18, widthFactor),
                                        ),
                                        SizedBox(
                                          width: Scaler.scaleWidgetWidth(
                                              15, widthFactor),
                                        ),
                                        Text(
                                          "Spotify Playlists",
                                          style: theme.textTheme.headline3
                                              .copyWith(
                                            fontSize: Scaler.scaleWidgetWidth(
                                                18, widthFactor),
                                          ),
                                        ),
                                      ],
                                    ),
                                    MaterialButton(
                                      color: Colors.blueAccent.withOpacity(0.2),
                                      elevation: 0,
                                      height:
                                      Scaler.scaleWidgetHeight(27, heightFactor),
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8.0),
                                          side: BorderSide(
                                              color: Colors.blueAccent.withOpacity(0.5), width: 1.5)),
                                      onPressed: () async {
                                        const url = 'https://www.instagram.com/themitpost/';
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                      child: Text(
                                        "FOLLOW",
                                        style: TextStyle(
                                            color: theme.textTheme.headline3.color.withOpacity(0.7),
                                            fontSize: Scaler.scaleWidgetHeight(
                                                11, heightFactor),
                                            letterSpacing: 1.35,
                                            fontFamily: bold),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container();
                      } else if (index == 3) {
                        return isSpotifySectionEnabled
                            ? Container(
                                height: Scaler.scaleWidgetHeight(
                                    kPlaylistSectionHeight, heightFactor),
                                child: FutureBuilder<List<Instagram>>(
                                  future: futurePosts,
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return snapshot.data.length == 0
                                          ? Center(
                                              child: Container(
                                                height:
                                                    Scaler.scaleWidgetHeight(
                                                        kPlaylistSectionHeight,
                                                        heightFactor),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.6,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.max,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
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
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : ListView.builder(
                                              physics: BouncingScrollPhysics(),
                                              scrollDirection: Axis.horizontal,
                                              itemCount: snapshot.data.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return GestureDetector(
                                                  onTap: () {},
                                                  child: Container(
                                                    child: Card(
                                                      semanticContainer: true,
                                                      clipBehavior: Clip
                                                          .antiAliasWithSaveLayer,
                                                      child: FadeInImage
                                                          .memoryNetwork(
                                                        placeholder:
                                                            kTransparentImage,
                                                        image: snapshot
                                                            .data[index]
                                                            .imageUrl,
                                                      ),
                                                      shape:
                                                          RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10.0),
                                                      ),
                                                      elevation: 5,
                                                      margin:
                                                          EdgeInsets.all(10),
                                                    ),
                                                  ),
                                                );
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
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              Icon(
                                                FontAwesomeIcons
                                                    .exclamationTriangle,
                                                size: 40,
                                                color: theme
                                                    .colorScheme.primaryVariant
                                                    .withOpacity(0.7),
                                              ),
                                              SizedBox(
                                                height: 15,
                                              ),
                                              Text(
                                                "An error ocurred :(",
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
                              )
                            : Container();
                      } else if (index == 4) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(
                            Scaler.scaleWidgetWidth(16, widthFactor),
                            Scaler.scaleWidgetHeight(2, heightFactor),
                            Scaler.scaleWidgetHeight(8, widthFactor),
                            Scaler.scaleWidgetHeight(2, heightFactor),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Icon(
                                    FontAwesomeIcons.twitter,
                                    color: theme.colorScheme.primaryVariant,
                                    size: Scaler.scaleWidgetWidth(
                                        18, widthFactor),
                                  ),
                                  SizedBox(
                                    width: Scaler.scaleWidgetWidth(
                                        15, widthFactor),
                                  ),
                                  Text(
                                    "Twitter Timeline",
                                    style: theme.textTheme.headline3.copyWith(
                                      fontSize: Scaler.scaleWidgetWidth(
                                          18, widthFactor),
                                    ),
                                  ),
                                ],
                              ),
                              MaterialButton(
                                color: Colors.blueAccent.withOpacity(0.2),
                                elevation: 0,
                                height:
                                    Scaler.scaleWidgetHeight(27, heightFactor),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                    side: BorderSide(
                                        color: Colors.blueAccent.withOpacity(0.5), width: 1.5)),
                                onPressed: () async {
                                  const url = 'https://twitter.com/themitpost';
                                  if (await canLaunch(url)) {
                                    await launch(url);
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                                child: Text(
                                  "FOLLOW",
                                  style: TextStyle(
                                    color: theme.textTheme.headline3.color.withOpacity(0.7),
                                      fontSize: Scaler.scaleWidgetHeight(
                                          11, heightFactor),
                                      letterSpacing: 1.35,
                                      fontFamily: bold),
                                ),
                              ),
                            ],
                          ),
                        );
                      } else if (index ==
                          snapshot.data.length + kSectionPositionOffset - 1) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: Scaler.scaleWidgetHeight(150, heightFactor),
                          ),
                          child: Container(
                            child: GestureDetector(
                              onTap: () async {
                                String url = _generateTweetLink(snapshot
                                    .data[index - kSectionPositionOffset].id);
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: TweetCard(
                                tweet: _removeLinks(snapshot
                                    .data[index - kSectionPositionOffset]
                                    .caption),
                                date: _dateFormatter(snapshot
                                    .data[index - kSectionPositionOffset].date),
                                time: _convertTimeToIST(_timeFormatter(snapshot
                                    .data[index - kSectionPositionOffset]
                                    .date)),
                                imageURL: snapshot
                                    .data[index - kSectionPositionOffset]
                                    .imageUrl,
                              ),
                            ),
                          ),
                        );
                      } else {
                        if (snapshot.data[index - kSectionPositionOffset]
                                .caption.length >
                            10) {
                          return Container(
                            child: GestureDetector(
                              onTap: () async {
                                String url = _generateTweetLink(snapshot
                                    .data[index - kSectionPositionOffset].id);
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  throw 'Could not launch $url';
                                }
                              },
                              child: TweetCard(
                                tweet: _removeLinks(snapshot
                                    .data[index - kSectionPositionOffset]
                                    .caption),
                                date: _dateFormatter(snapshot
                                    .data[index - kSectionPositionOffset].date),
                                time: _convertTimeToIST(_timeFormatter(snapshot
                                    .data[index - kSectionPositionOffset]
                                    .date)),
                                imageURL: snapshot
                                    .data[index - kSectionPositionOffset]
                                    .imageUrl,
                              ),
                            ),
                          );
                        }
                      }

                      return Container();
                    },
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
                                "assets/images/cat-06.png",
                                height: 130,
                              ),
                              SizedBox(
                                height: 15,
                              ),
                              Text(
                                "Failed to get the latest posts",
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
                                      futurePosts = fetchPosts();
                                      futureTwitterPosts =
                                          fetchPostsTwitter(_twitterOauth);
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
                return Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ),
      ),
    );
  }

  ///Utility Formatting Functions
  String _dateFormatter(String rawString) {
    String day = rawString.substring(0, 3);
    String date = rawString.substring(4, 10);
    String year = rawString.substring(26);
    String outputString = day + " - " + date + ", " + year;
    return outputString;
  }

  String _timeFormatter(String rawString) {
    String outputString = rawString.substring(11, 16);
    return outputString;
  }

  String _generateTweetLink(String id) {
    String url = "https://twitter.com/themitpost/status/";
    String outputString = url + id;
    print(outputString);
    return outputString;
  }

  String _removeLinks(String rawString) {
    String outputString;
    if (rawString.contains("http")) {
      int index = rawString.indexOf("http");
      outputString = rawString.substring(0, index);
    } else {
      outputString = rawString;
    }
    return outputString.trim();
  }

  String truncateCaption(String caption) {
    return caption.length > 240
        ? caption.substring(0, 240).trim() + "..."
        : caption;
  }

  String _removeHashtags(String caption) {
    return caption.contains("#")
        ? caption.trim().substring(0, caption.indexOf("#"))
        : caption;
  }

  _convertTimeToIST(String time) {
    int inputHour = int.parse(time.substring(0, 2));
    int inputMin = int.parse(time.substring(3, 5));
    int outputMin = 0;
    int outputHour = 0;
    String minutes = "";
    outputMin = inputMin + 30;

    if (outputMin > 59) {
      outputHour += 1;
      outputMin %= 60;
    }

    if (outputMin < 10) {
      minutes = "0" + outputMin.toString();
    } else {
      minutes = outputMin.toString();
    }

    outputHour = outputHour + inputHour + 5;

    if (outputHour < 13) {
      return outputHour.toString() + ":" + minutes + " am";
    } else {
      outputHour -= 12;
      return outputHour.toString() + ":" + minutes + " pm";
    }
  }
}
