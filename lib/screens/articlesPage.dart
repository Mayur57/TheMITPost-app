import 'dart:async';

import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_vibrate/flutter_vibrate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/themes.dart';
import 'package:mit_post/widgets/darkModeAppBarIcon.dart';
import 'package:provider/provider.dart';
import '../models/Articles.dart';
import '../util/strings.dart';
import '../widgets/articleCard.dart';

class ArticlesPage extends StatefulWidget {
  @override
  _ArticlesPageState createState() => _ArticlesPageState();
}

class _ArticlesPageState extends State<ArticlesPage>
    with AutomaticKeepAliveClientMixin<ArticlesPage> {
  @override
  bool get wantKeepAlive => true;

  Future<List<Article>> futureArticles;
  String _listFilter = "All";
  String _value = "All";
  String rawData = "";
  double heightFactor = 8.94;
  double widthFactor = 4.31;
  bool isFetchingData = true;
  Timer _timer;
  bool timeout = false;
  bool _deviceVibrationCapabilities = true;
  bool _searchModeActivated = false;
  TextEditingController _searchBarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureArticles = fetchArticles();
    _timeout();
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  Future<void> _refresh() async {
    print("Refreshing items...");
    setState(() {
      isFetchingData = true;
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

  vibration() async {
    bool canVibrate = await Vibrate.canVibrate;
    setState(() {
      _deviceVibrationCapabilities = canVibrate;
      _deviceVibrationCapabilities
          ? print("Device vibration is supported")
          : print("Device vibration is not supported");
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    ThemeData theme = Theme.of(context);
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    TextStyle sortbarTextTheme = theme.textTheme.bodyText1.copyWith(
      color: theme.textTheme.bodyText1.color.withOpacity(0.5),
      fontSize: Scaler.scaleWidgetWidth(16, widthFactor),
    );
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: _listFilter == "All"
              ? FutureBuilder<List<Article>>(
                  future: futureArticles,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      isFetchingData = false;
                      return AnimationLimiter(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Center(
                                child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.925,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              articles,
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
                                        SafeArea(
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16.0),
                                              child: _searchModeActivated

                                                  /// TODO (Mayur57 06:24 14-01-2021) -> Searchbar for Articles
                                                  /// Targeted release version: 3.1.0
                                                  /// Resource(s) used: NONE
                                                  ? Container(
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.9,
                                                      height: 45,
                                                      decoration: BoxDecoration(
                                                          border: Border.all(
                                                            color: darkMode
                                                                ? Color(
                                                                    0xFF2B2C30)
                                                                : Color(0xFF2B2C30)
                                                                    .withOpacity(
                                                                        0.3),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                      child: TextField(
                                                        controller:
                                                            _searchBarController,
                                                        cursorColor: AppTheme
                                                            .mitPostOrange,
                                                        autofocus: true,
                                                        decoration:
                                                            InputDecoration(
                                                          border:
                                                              InputBorder.none,
                                                          focusedBorder:
                                                              InputBorder.none,
                                                          enabledBorder:
                                                              InputBorder.none,
                                                          errorBorder:
                                                              InputBorder.none,
                                                          disabledBorder:
                                                              InputBorder.none,
                                                          contentPadding:
                                                              EdgeInsets
                                                                  .symmetric(
                                                                      vertical:
                                                                          15),
                                                          fillColor: Color(
                                                                  0xFF2B2C30)
                                                              .withOpacity(0.7),
                                                          isDense: true,
                                                          prefixIcon: Icon(
                                                              Icons.search),
                                                          hintText: "Search",
                                                          hintStyle: theme
                                                              .textTheme
                                                              .bodyText2
                                                              .copyWith(
                                                            color: theme
                                                                .textTheme
                                                                .bodyText2
                                                                .color
                                                                .withOpacity(
                                                                    0.3),
                                                          ),
                                                        ),
                                                      ),
                                                    )

                                                  ///Category Bar
                                                  : Container(
                                                      // height: 30,
                                                      // color: Theme.of(context).cardColor,
                                                      decoration: BoxDecoration(
                                                          color:
                                                              theme.cardColor,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8))),
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.925,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal:
                                                                    8.0),
                                                        child: Row(
                                                          mainAxisSize:
                                                              MainAxisSize.max,
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.2,
                                                              child: Center(
                                                                child: Text(
                                                                  "Category: ",
                                                                  style:
                                                                      sortbarTextTheme,
                                                                ),
                                                              ),
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.01,
                                                            ),
                                                            SizedBox(
                                                              width: MediaQuery.of(
                                                                          context)
                                                                      .size
                                                                      .width *
                                                                  0.65,
                                                              child:
                                                                  DropdownButtonHideUnderline(
                                                                child:
                                                                    DropdownButton(
                                                                  dropdownColor:
                                                                      theme
                                                                          .cardColor,
                                                                  icon: Icon(
                                                                    Icons
                                                                        .keyboard_arrow_down,
                                                                    size: 26,
                                                                  ),
                                                                  value: _value,
                                                                  items: [
                                                                    DropdownMenuItem(
                                                                      child:
                                                                          Text(
                                                                        "All",
                                                                        style:
                                                                            sortbarTextTheme,
                                                                      ),
                                                                      value:
                                                                          "All",
                                                                    ),
                                                                    DropdownMenuItem(
                                                                      child:
                                                                          Text(
                                                                        "Arts & Culture",
                                                                        style:
                                                                            sortbarTextTheme,
                                                                      ),
                                                                      value:
                                                                          "Arts & Culture",
                                                                    ),
                                                                    DropdownMenuItem(
                                                                      child:
                                                                          Text(
                                                                        "Campus",
                                                                        style:
                                                                            sortbarTextTheme,
                                                                      ),
                                                                      value:
                                                                          "Campus",
                                                                    ),
                                                                    DropdownMenuItem(
                                                                      child:
                                                                          Text(
                                                                        "Fests",
                                                                        style:
                                                                            sortbarTextTheme,
                                                                      ),
                                                                      value:
                                                                          "Fests",
                                                                    ),
                                                                    DropdownMenuItem(
                                                                      child:
                                                                          Text(
                                                                        "Interviews",
                                                                        style:
                                                                            sortbarTextTheme,
                                                                      ),
                                                                      value:
                                                                          "Interviews",
                                                                    ),
                                                                    DropdownMenuItem(
                                                                      child:
                                                                          Text(
                                                                        "National & Global",
                                                                        style:
                                                                            sortbarTextTheme,
                                                                      ),
                                                                      value:
                                                                          "National & World",
                                                                    ),
                                                                    DropdownMenuItem(
                                                                      child:
                                                                          Text(
                                                                        "Science & Technology",
                                                                        style:
                                                                            sortbarTextTheme,
                                                                      ),
                                                                      value:
                                                                          "Science & Technology",
                                                                    ),
                                                                    DropdownMenuItem(
                                                                      child:
                                                                          Text(
                                                                        "FAQ",
                                                                        style:
                                                                            sortbarTextTheme,
                                                                      ),
                                                                      value:
                                                                          "FAQ",
                                                                    ),
                                                                    DropdownMenuItem(
                                                                      child:
                                                                          Text(
                                                                        "Miscellaneous",
                                                                        style:
                                                                            sortbarTextTheme,
                                                                      ),
                                                                      value:
                                                                          "Miscellaneous",
                                                                    ),
                                                                  ],
                                                                  onChanged:
                                                                      (String
                                                                          value) {
                                                                    setState(
                                                                        () {
                                                                      _value =
                                                                          value;
                                                                      _listFilter =
                                                                          value;
                                                                    });
                                                                  },
                                                                ),
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return AnimationConfiguration.staggeredList(
                                position: index,
                                duration: const Duration(milliseconds: 400),
                                child: SlideAnimation(
                                  verticalOffset: 50.0,
                                  child: FadeInAnimation(
                                    child: ArticleCard(
                                      theme: theme,
                                      id: snapshot.data[index - 1].id,
                                      title: snapshot.data[index - 1].title,
                                      author: snapshot.data[index - 1].author,
                                      imageUrl:
                                          snapshot.data[index - 1].imageUrl,
                                      description:
                                          snapshot.data[index - 1].description,
                                      link: snapshot.data[index - 1].link,
                                      date: snapshot.data[index - 1].day +
                                          ' ' +
                                          snapshot.data[index - 1].month +
                                          ' ' +
                                          snapshot.data[index - 1].year,
                                    ),
                                  ),
                                ),
                              );
                            }
                          },
                        ),
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
                                    "Cannot fetch articles",
                                    textAlign: TextAlign.center,
                                    style: theme.textTheme.headline3,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Container(
                                    width: Scaler.scaleWidgetWidth(
                                        300, widthFactor),
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
                )
              : FutureBuilder<List<Article>>(
                  future: futureArticles,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return AnimationLimiter(
                        child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          itemCount: snapshot.data.length + 1,
                          itemBuilder: (BuildContext context, int index) {
                            if (index == 0) {
                              return Center(
                                child: Container(
                                  width:
                                  MediaQuery.of(context).size.width * 0.925,
                                  child: Center(
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 40,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                          children: [
                                            Text(
                                              articles,
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
                                        SafeArea(
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 16.0),
                                              child: _searchModeActivated

                                              /// TODO (Mayur57 06:24 14-01-2021) -> Searchbar for Articles
                                              /// Targeted release version: 3.1.0
                                              /// Resource(s) used: NONE
                                                  ? Container(
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.9,
                                                height: 45,
                                                decoration: BoxDecoration(
                                                    border: Border.all(
                                                      color: darkMode
                                                          ? Color(
                                                          0xFF2B2C30)
                                                          : Color(0xFF2B2C30)
                                                          .withOpacity(
                                                          0.3),
                                                    ),
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius
                                                            .circular(
                                                            8))),
                                                child: TextField(
                                                  controller:
                                                  _searchBarController,
                                                  cursorColor: AppTheme
                                                      .mitPostOrange,
                                                  autofocus: true,
                                                  decoration:
                                                  InputDecoration(
                                                    border:
                                                    InputBorder.none,
                                                    focusedBorder:
                                                    InputBorder.none,
                                                    enabledBorder:
                                                    InputBorder.none,
                                                    errorBorder:
                                                    InputBorder.none,
                                                    disabledBorder:
                                                    InputBorder.none,
                                                    contentPadding:
                                                    EdgeInsets
                                                        .symmetric(
                                                        vertical:
                                                        15),
                                                    fillColor: Color(
                                                        0xFF2B2C30)
                                                        .withOpacity(0.7),
                                                    isDense: true,
                                                    prefixIcon: Icon(
                                                        Icons.search),
                                                    hintText: "Search",
                                                    hintStyle: theme
                                                        .textTheme
                                                        .bodyText2
                                                        .copyWith(
                                                      color: theme
                                                          .textTheme
                                                          .bodyText2
                                                          .color
                                                          .withOpacity(
                                                          0.3),
                                                    ),
                                                  ),
                                                ),
                                              )

                                              ///Category Bar
                                                  : Container(
                                                // height: 30,
                                                // color: Theme.of(context).cardColor,
                                                decoration: BoxDecoration(
                                                    color:
                                                    theme.cardColor,
                                                    borderRadius:
                                                    BorderRadius.all(
                                                        Radius
                                                            .circular(
                                                            8))),
                                                width:
                                                MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                    0.925,
                                                child: Padding(
                                                  padding:
                                                  const EdgeInsets
                                                      .symmetric(
                                                      horizontal:
                                                      8.0),
                                                  child: Row(
                                                    mainAxisSize:
                                                    MainAxisSize.max,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                    children: [
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width *
                                                            0.2,
                                                        child: Center(
                                                          child: Text(
                                                            "Category: ",
                                                            style:
                                                            sortbarTextTheme,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width *
                                                            0.01,
                                                      ),
                                                      SizedBox(
                                                        width: MediaQuery.of(
                                                            context)
                                                            .size
                                                            .width *
                                                            0.65,
                                                        child:
                                                        DropdownButtonHideUnderline(
                                                          child:
                                                          DropdownButton(
                                                            dropdownColor:
                                                            theme
                                                                .cardColor,
                                                            icon: Icon(
                                                              Icons
                                                                  .keyboard_arrow_down,
                                                              size: 26,
                                                            ),
                                                            value: _value,
                                                            items: [
                                                              DropdownMenuItem(
                                                                child:
                                                                Text(
                                                                  "All",
                                                                  style:
                                                                  sortbarTextTheme,
                                                                ),
                                                                value:
                                                                "All",
                                                              ),
                                                              DropdownMenuItem(
                                                                child:
                                                                Text(
                                                                  "Arts & Culture",
                                                                  style:
                                                                  sortbarTextTheme,
                                                                ),
                                                                value:
                                                                "Arts & Culture",
                                                              ),
                                                              DropdownMenuItem(
                                                                child:
                                                                Text(
                                                                  "Campus",
                                                                  style:
                                                                  sortbarTextTheme,
                                                                ),
                                                                value:
                                                                "Campus",
                                                              ),
                                                              DropdownMenuItem(
                                                                child:
                                                                Text(
                                                                  "Fests",
                                                                  style:
                                                                  sortbarTextTheme,
                                                                ),
                                                                value:
                                                                "Fests",
                                                              ),
                                                              DropdownMenuItem(
                                                                child:
                                                                Text(
                                                                  "Interviews",
                                                                  style:
                                                                  sortbarTextTheme,
                                                                ),
                                                                value:
                                                                "Interviews",
                                                              ),
                                                              DropdownMenuItem(
                                                                child:
                                                                Text(
                                                                  "National & Global",
                                                                  style:
                                                                  sortbarTextTheme,
                                                                ),
                                                                value:
                                                                "National & World",
                                                              ),
                                                              DropdownMenuItem(
                                                                child:
                                                                Text(
                                                                  "Science & Technology",
                                                                  style:
                                                                  sortbarTextTheme,
                                                                ),
                                                                value:
                                                                "Science & Technology",
                                                              ),
                                                              DropdownMenuItem(
                                                                child:
                                                                Text(
                                                                  "FAQ",
                                                                  style:
                                                                  sortbarTextTheme,
                                                                ),
                                                                value:
                                                                "FAQ",
                                                              ),
                                                              DropdownMenuItem(
                                                                child:
                                                                Text(
                                                                  "Miscellaneous",
                                                                  style:
                                                                  sortbarTextTheme,
                                                                ),
                                                                value:
                                                                "Miscellaneous",
                                                              ),
                                                            ],
                                                            onChanged:
                                                                (String
                                                            value) {
                                                              setState(
                                                                      () {
                                                                    _value =
                                                                        value;
                                                                    _listFilter =
                                                                        value;
                                                                  });
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            } else {
                              return _categoryValueSetter(
                                          snapshot.data[index - 1].category) ==
                                      _listFilter
                                  ? AnimationConfiguration.staggeredList(
                                      position: index,
                                      duration:
                                          const Duration(milliseconds: 400),
                                      child: SlideAnimation(
                                        verticalOffset: 50.0,
                                        child: FadeInAnimation(
                                          child: ArticleCard(
                                            theme: theme,
                                            id: snapshot.data[index - 1].id,
                                            title:
                                                snapshot.data[index - 1].title,
                                            author:
                                                snapshot.data[index - 1].author,
                                            imageUrl: snapshot
                                                .data[index - 1].imageUrl,
                                            description: snapshot
                                                .data[index - 1].description,
                                            link: snapshot.data[index - 1].link,
                                            date: snapshot.data[index - 1].day +
                                                ' ' +
                                                snapshot.data[index - 1].month +
                                                ' ' +
                                                snapshot.data[index - 1].year,
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
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              FontAwesomeIcons.exclamationTriangle,
                              size: 40,
                              color: theme.colorScheme.primaryVariant
                                  .withOpacity(0.7),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.65,
                              child: Text(
                                "Could not connect to the internet. Please check your connection and try again.",
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return !timeout
                        ? Center(child: CircularProgressIndicator())
                        : Container();
                  },
                ),
        ),
      ),
    );
  }

  List<String> artsAndCultureList = [
    "Arts & Culture".toLowerCase(),
    "Finely Tuned".toLowerCase(),
    "iambic instincts".toLowerCase(),
  ];

  List<String> campusList = [
    "Campus".toLowerCase(),
    "Campus Projects".toLowerCase(),
    "Event Reports".toLowerCase(),
    "Freshers' Corner".toLowerCase(),
  ];

  List<String> festsList = [
    "Fests".toLowerCase(),
    "Revels".toLowerCase(),
    "TechTatva".toLowerCase(),
    "Tech Tatva".toLowerCase(),
  ];

  List<String> interviewsList = [
    "Interviews".toLowerCase(),
    "Sitting Down With".toLowerCase(),
  ];

  List<String> nationalAndWorldList = [
    "National & World".toLowerCase(),
    "Between the Lines".toLowerCase(),
    "in transit".toLowerCase(),
    "Fine Print".toLowerCase(),
  ];

  List<String> scienceAndTechnologyList = [
    "Science and Technology".toLowerCase(),
    "Amplified".toLowerCase(),
    "Dividend".toLowerCase(),
    "Future Bytes".toLowerCase(),
    "Hashtag".toLowerCase(),
  ];

  List<String> othersList = [
    "General".toLowerCase(),
  ];

  List<String> FAQ = [
    "FAQ".toLowerCase(),
  ];

  String _categoryValueSetter(String receivedString) {
    String element = receivedString.trim().toLowerCase();
    if (artsAndCultureList.contains(element)) {
      return "Arts & Culture";
    } else if (campusList.contains(element)) {
      return "Campus";
    } else if (festsList.contains(element)) {
      return "Fests";
    } else if (interviewsList.contains(element)) {
      return "Interviews";
    } else if (nationalAndWorldList.contains(element)) {
      return "National & World";
    } else if (scienceAndTechnologyList.contains(element)) {
      return "Science & Technology";
    } else if (othersList.contains(element)) {
      return "Miscellaneous";
    } else if (FAQ.contains(element)) {
      return "FAQ";
    } else {
      return "Miscellaneous";
    }
  }

  _formatHTML(String html) {
    return parse(parse(html).body.text).documentElement.text;
  }
}
