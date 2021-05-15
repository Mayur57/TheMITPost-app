import 'dart:async';
import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/themes.dart';
import 'package:mit_post/widgets/darkModeAppBarIcon.dart';
import 'package:mit_post/widgets/noticeCard.dart';
import 'package:provider/provider.dart';
import '../models/Notices.dart';
import '../widgets/appBar.dart';
import '../util/strings.dart';

class NoticesPage extends StatefulWidget {
  @override
  _NoticesPageState createState() => _NoticesPageState();
}

class _NoticesPageState extends State<NoticesPage>
    with AutomaticKeepAliveClientMixin<NoticesPage> {
  @override
  bool get wantKeepAlive => true;

  Future<List<Notice>> futureNotices;
  double heightFactor = 8.94;
  double widthFactor = 4.31;

  Timer _timer;
  bool timeout = false;

  @override
  void initState() {
    super.initState();
    futureNotices = fetchNotices();
    _timeout();
  }

  Future<void> _refresh() async {
    print("Refreshing items...");
    setState(() {
      futureNotices = fetchNotices();
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
    return Center(
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        // appBar: MyAppBar(title: 'Notices'),
        body: RefreshIndicator(
          onRefresh: _refresh,
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: FutureBuilder<List<Notice>>(
              future: futureNotices,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.length + 1,
                    itemBuilder: (BuildContext context, int index) {
                      if (index == 0) {
                        return Column(
                          children: [
                            SizedBox(height: 40,),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.925,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    notices,
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
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 16, 8, 0),
                                child: Text("Recent Notices",
                                    style: theme.textTheme.headline3
                                        .copyWith(fontSize: 24)),
                              ),
                            ),
                            Align(
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
                      } else if (index > 4) {
                        return OldNoticeCard(
                          title:
                              snapshot.data[snapshot.data.length - index].title,
                          message: snapshot
                              .data[snapshot.data.length - index].content,
                          date:
                              snapshot.data[snapshot.data.length - index].date,
                          image: snapshot
                              .data[snapshot.data.length - index].imageUrl,
                          pdf: snapshot
                              .data[snapshot.data.length - index].pdfUrl,
                        );
                      } else if (index == 4) {
                        return Column(
                          children: <Widget>[
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(16, 32, 8, 0),
                                child: Text("Older Notices",
                                    style: theme.textTheme.headline3
                                        .copyWith(fontSize: 24)),
                              ),
                            ),
                            Align(
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
                            OldNoticeCard(
                              title: snapshot
                                  .data[snapshot.data.length - index].title,
                              message: snapshot
                                  .data[snapshot.data.length - index].content,
                              time: snapshot
                                  .data[snapshot.data.length - index].time,
                              date: snapshot
                                  .data[snapshot.data.length - index].date,
                              image: snapshot
                                  .data[snapshot.data.length - index].imageUrl,
                              pdf: snapshot
                                  .data[snapshot.data.length - index].pdfUrl,
                            ),
                          ],
                        );
                      } else if (index == snapshot.data.length) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 150.0),
                          child: OldNoticeCard(
                            title: snapshot
                                .data[snapshot.data.length - index].title,
                            message: snapshot
                                .data[snapshot.data.length - index].content,
                            time: snapshot
                                .data[snapshot.data.length - index].time,
                            date: snapshot
                                .data[snapshot.data.length - index].date,
                            image: snapshot
                                .data[snapshot.data.length - index].imageUrl,
                            pdf: snapshot
                                .data[snapshot.data.length - index].pdfUrl,
                          ),
                        );
                      } else {
                        return NoticeCard(
                          title:
                              snapshot.data[snapshot.data.length - index].title,
                          message: snapshot
                              .data[snapshot.data.length - index].content,
                          date:
                              snapshot.data[snapshot.data.length - index].date,
                          image: snapshot
                              .data[snapshot.data.length - index].imageUrl,
                          pdf: snapshot
                              .data[snapshot.data.length - index].pdfUrl,
                        );
                      }
                    },
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
                                  "assets/images/cat-03.png",
                                  height: 200,
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Text(
                                  "Cannot fetch notices",
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
                                        futureNotices = fetchNotices();
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
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
