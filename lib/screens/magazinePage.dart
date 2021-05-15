import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../models/Magazines.dart';
import '../widgets/magazineCard.dart';
import 'package:mit_post/util/state.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'package:mit_post/util/themes.dart';

class MagazinePage extends StatefulWidget {
  @override
  _MagazinePageState createState() => _MagazinePageState();
}

class _MagazinePageState extends State<MagazinePage> {
  Future<List<Magazine>> futureMagazines;
  Timer _timer;
  bool timeout = false;

  @override
  void initState() {
    super.initState();
    futureMagazines = fetchMagazines();
    print(futureMagazines);
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
    bool themeToggle = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          child: FutureBuilder<List<Magazine>>(
            future: futureMagazines,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return AnimationLimiter(
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      if(index == 0){
                        return Column(
                          children: [
                            SizedBox(height: 10,),
                            Align(alignment: Alignment.centerLeft,child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);}),
                            )),
                            SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.925,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    "Magazines",
                                    style: theme.textTheme.headline1,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Text(
                                "The Standard is our quarterly published magazine. These are all the editions of the magazine published. Click on any one of these to read.",
                              ),
                            ),
                            SizedBox(height: 20,),
                            AnimationConfiguration.staggeredList(
                              position: index,
                              duration: const Duration(milliseconds: 400),
                              child: SlideAnimation(
                                verticalOffset: 50.0,
                                child: FadeInAnimation(
                                  child: MagazineCard(
                                    theme: theme,
                                    id: snapshot
                                        .data[snapshot.data.length - index - 1].id,
                                    title: snapshot
                                        .data[snapshot.data.length - index - 1].title,
                                    content: snapshot
                                        .data[snapshot.data.length - index - 1]
                                        .content,
                                    imageLink: snapshot
                                        .data[snapshot.data.length - index - 1]
                                        .imageLink,
                                    pdfLink: snapshot
                                        .data[snapshot.data.length - index - 1]
                                        .pdfLink,
                                    date: snapshot
                                        .data[snapshot.data.length - index - 1].date,
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }
                      else {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        duration: const Duration(milliseconds: 400),
                        child: SlideAnimation(
                          verticalOffset: 50.0,
                          child: FadeInAnimation(
                            child: MagazineCard(
                              theme: theme,
                              id: snapshot
                                  .data[snapshot.data.length - index - 1].id,
                              title: snapshot
                                  .data[snapshot.data.length - index - 1].title,
                              content: snapshot
                                  .data[snapshot.data.length - index - 1]
                                  .content,
                              imageLink: snapshot
                                  .data[snapshot.data.length - index - 1]
                                  .imageLink,
                              pdfLink: snapshot
                                  .data[snapshot.data.length - index - 1]
                                  .pdfLink,
                              date: snapshot
                                  .data[snapshot.data.length - index - 1].date,
                            ),
                          ),
                        ),
                      );
                      }
                    },
                  ),
                );
              } else if (snapshot.hasError) {
                print('Snapshot error');
                return timeout
                    ? Center(
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: Column(
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
                                "Cannot fetch magazines",
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
                                      futureMagazines = fetchMagazines();
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
                        ),
                      )
                    : Center(
                        child: Column(
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
                        ),
                      );
              } else {
                return !timeout
                    ? Center(
                        child: Column(
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
                        ),
                      )
                    : Container();
              }
            },
          ),
        ),
      ),
    );
  }
}
