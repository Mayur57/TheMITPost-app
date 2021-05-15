import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:flutter/material.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/strings.dart';
import 'package:mit_post/util/themes.dart';
import 'package:provider/provider.dart';

class TweetCard extends StatelessWidget {
  const TweetCard({
    Key key,
    @required this.tweet,
    @required this.time,
    @required this.date,
    this.imageURL,
  });

  final String tweet;
  final String time;
  final String date;
  final String imageURL;

  final double heightFactor = 8.94;
  final double widthFactor = 4.31;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        shape: RoundedRectangleBorder(                        side: BorderSide(
          width: 1.25,
          color: darkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08),
        ),borderRadius: BorderRadius.circular(10)),
        elevation: 0,
        child: ClipPath(
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: Text(
                        tweet,
                        style: theme.textTheme.bodyText1.copyWith(
                          fontSize: Scaler.scaleWidgetWidth(15, widthFactor),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 12.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            date,
                            style: TextStyle(
                              fontSize:
                                  Scaler.scaleWidgetWidth(12, widthFactor),
                              fontFamily: medium,
                            ),
                          ),
                          Text(time,
                              style: TextStyle(
                                fontSize: 12, fontFamily: medium,
                              )),
                        ],
                      ),
                    ),
                    _isAttachmentImagePresent(imageURL)
                        ? Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                top: 8.0,
                              ),
                              child: Row(
                                children: <Widget>[
                                  Icon(
                                    Icons.image,
                                    color: AppTheme.mitPostOrange,
                                    size: 14,
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.7,
                                      child: Text(
                                        "This tweet has attached media. Click to view.",
                                        style: TextStyle(
                                          color: AppTheme.mitPostOrange,
                                          fontSize: 12,
                                        ),
                                        softWrap: true,
                                      ))
                                ],
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ],
          ),
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(3),
            ),
          ),
        ),
      ),
    );
  }

  _isAttachmentImagePresent(String imageLink) {
    return imageLink != 'NO IMAGE' ? true : false;
  }
}
