import 'dart:ffi';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mit_post/screens/pdfPage.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/strings.dart';
import 'package:mit_post/util/themes.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class OldNoticeCard extends StatelessWidget {
  const OldNoticeCard({
    Key key,
    @required this.title,
    this.message,
    this.image,
    this.time,
    this.date,
    this.pdf,
  });

  final String title;
  final String message;
  final String image;
  final String time;
  final String date;
  final String pdf;

  final double heightFactor = 8.94;
  final double widthFactor = 4.31;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          showModalBottomSheet(
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              backgroundColor: theme.cardColor,
              context: context,
              builder: (context) {
                return SingleChildScrollView(
                  child: Container(
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                        Scaler.scaleWidgetWidth(16, widthFactor),
                        Scaler.scaleWidgetHeight(16, heightFactor),
                        Scaler.scaleWidgetWidth(16, widthFactor),
                        Scaler.scaleWidgetHeight(36, heightFactor),
                      ),
                      child: Wrap(
                        children: [
                          Center(
                            child: Container(
                              width: Scaler.scaleWidgetWidth(40, widthFactor),
                              height: 5,
                              // color: Colors.white.withOpacity(0.5),
                              decoration: BoxDecoration(
                                color: darkMode ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.3),
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              Scaler.scaleWidgetWidth(0, widthFactor),
                              Scaler.scaleWidgetHeight(24, heightFactor),
                              Scaler.scaleWidgetWidth(0, widthFactor),
                              Scaler.scaleWidgetHeight(0, heightFactor),
                            ),
                            child: Center(
                              child: Container(
                                width: MediaQuery.of(context).size.width - 50,
                                child: Text(
                                  title,
                                  style: theme.textTheme.headline3.copyWith(
                                    fontSize: 22,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              Scaler.scaleWidgetWidth(8, widthFactor),
                              Scaler.scaleWidgetHeight(16, heightFactor),
                              Scaler.scaleWidgetWidth(16, widthFactor),
                              Scaler.scaleWidgetHeight(16, heightFactor),
                            ),
                            child: Text(
                              message,
                              style: theme.textTheme.bodyText1,
                            ),
                          ),
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                time != null
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Posted on: " + time),
                                      )
                                    : Container(),
                                date != ""
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text("Posted on: " + date),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                          image != ""
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 20.0, horizontal: 8.0),
                                  child: Center(
                                    child: CachedNetworkImage(
                                      imageUrl: image,
                                      placeholder: (context, url) => Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          Center(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 20.0),
                                          child: Text(
                                              "Error: Could not load image"),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 20,
                          ),
                          pdf != ""
                              ? Center(
                                  child: FlatButton(
                                    height: 45,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        width: 1,
                                        color: AppTheme.mitPostOrange.withOpacity(0.45),
                                      ),
                                      borderRadius:
                                          BorderRadius.circular(10.0),
                                    ),
                                    color: AppTheme.mitPostOrange.withOpacity(0.2),
                                    child: Container(
                                      width: double.infinity,
                                      child: Center(
                                        child: Text(
                                          "VIEW ATTACHMENT",
                                          style: TextStyle(
                                              color: theme.textTheme.headline3.color.withOpacity(0.7),
                                              letterSpacing: 1.35,
                                              fontFamily: medium),
                                        ),
                                      ),
                                    ),
                                    onPressed: () async {
                                      if (await canLaunch(pdf)) {
                                        launch(pdf);
                                      } else {
                                        throw 'Could not launch $pdf';
                                      }
                                    },
                                  ),
                                )
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Text(
                    title,
                    style: theme.textTheme.headline3
                        .copyWith(fontSize: 16, fontFamily: medium),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class NoticeCard extends StatelessWidget {
  const NoticeCard({
    Key key,
    @required this.title,
    this.message,
    this.image,
    this.time,
    this.date,
    this.pdf,
  });

  final String title;
  final String message;
  final String image;
  final String time;
  final String date;
  final String pdf;

  final double heightFactor = 8.94;
  final double widthFactor = 4.31;

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            isScrollControlled: true,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            backgroundColor: theme.cardColor,
            context: context,
            builder: (context) {
              return SingleChildScrollView(
                child: Container(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 32.0),
                    child: Wrap(
                      children: [
                        Center(
                          child: Container(
                            width: Scaler.scaleWidgetWidth(40, widthFactor),
                            height: 5,
                            // color: Colors.white.withOpacity(0.5),
                            decoration: BoxDecoration(
                                color: darkMode ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.3),
                                borderRadius: BorderRadius.all(Radius.circular(20))
                            ),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              Scaler.scaleWidgetWidth(0, widthFactor),
                              Scaler.scaleWidgetHeight(24, heightFactor),
                              Scaler.scaleWidgetWidth(0, widthFactor),
                              Scaler.scaleWidgetHeight(0, heightFactor),
                            ),
                            child: Text(
                              title,
                              style: theme.textTheme.headline3
                                  .copyWith(fontSize: 22),
                              softWrap: true,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(8, 16, 8, 16),
                          child: Text(
                            message,
                            style: theme.textTheme.bodyText1,
                          ),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              time != null
                                  ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Posted on: " + time),
                              )
                                  : Container(),
                              date != ""
                                  ? Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text("Posted on: " + date),
                              )
                                  : Container(),
                            ],
                          ),
                        ),
                        image != ""
                            ? Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20.0, horizontal: 8.0),
                          child: Center(
                            child: CachedNetworkImage(
                              imageUrl: image,
                              placeholder: (context, url) =>
                                  Center(
                                    child: CircularProgressIndicator(),
                                  ),
                              errorWidget: (context, url, error) =>
                                  Center(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 20.0),
                                      child:
                                      Text("Error: Could not load image"),
                                    ),
                                  ),
                            ),
                          ),
                        )
                            : Container(),
                        pdf != ""
                            ? Center(
                          child: FlatButton(
                            height: 45,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(
                                width: 1,
                                color: AppTheme.mitPostOrange.withOpacity(0.45),
                              ),
                              borderRadius:
                              BorderRadius.circular(10.0),
                            ),
                            color: AppTheme.mitPostOrange.withOpacity(0.2),
                            child: Container(
                              width: double.infinity,
                              child: Center(
                                child: Text(
                                  "VIEW ATTACHMENT",
                                  style: TextStyle(
                                      color: theme.textTheme.headline3.color.withOpacity(0.7),
                                      letterSpacing: 1.35,
                                      fontFamily: medium),
                                ),
                              ),
                            ),
                            onPressed: () async {
                              if (await canLaunch(pdf)) {
                                launch(pdf);
                              } else {
                                throw 'Could not launch $pdf';
                              }
                            },
                          ),
                        )
                            : Container(),
                        SizedBox(
                          height: 50,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1.25,
              color: darkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08),
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          elevation: 0,
          child: Wrap(
            children: <Widget>[
              Container(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          title,
                          style:
                          theme.textTheme.headline3.copyWith(fontSize: 18),
                        ),
                      ),
                      _isUploadDatePresent(date)
                          ? Padding(
                        padding:
                        const EdgeInsets.only(top: 2.0, bottom: 8),
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text("Posted on: " + date),
                          ],
                        ),
                      )
                          : Container(),
                      message == null
                          ? Align(
                        alignment: Alignment.topLeft,
                        child: Container(),
                      )
                          : Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          truncateMessage(message, 140),
                          style: theme.textTheme.bodyText2
                              .copyWith(fontSize: 14, fontFamily: medium),
                        ),
                      ),
                      _isAttachmentPresent(pdf)
                          ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: 8.0,
                          ),
                          child: Row(
                            children: <Widget>[
                              Icon(
                                FontAwesomeIcons.paperclip,
                                color: AppTheme.mitPostOrange,
                                size: 12,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Container(
                                width: MediaQuery
                                    .of(context)
                                    .size
                                    .width *
                                    0.7,
                                child: Text(
                                  "This notice has an attachment. Click to view.",
                                  softWrap: true,
                                  style: TextStyle(
                                    color: AppTheme.mitPostOrange,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      )
                          : Container(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String truncateMessage(String message, int length) {
    return message.length > length
        ? message.substring(0, length).trim() + "..."
        : message;
  }

  _isUploadDatePresent(String upload) {
    return upload != '' ? true : false;
  }

  _isAttachmentPresent(String pdfLink) {
    return pdfLink != "" ? true : false;
  }
}
