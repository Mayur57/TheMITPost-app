import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:mit_post/screens/pdfPage.dart';
import 'package:mit_post/util/strings.dart';
import 'package:flutter_html/flutter_html.dart';

class MagazineCard extends StatelessWidget {
  const MagazineCard({
    Key key,
    @required this.theme,
    this.id,
    this.title,
    this.content,
    this.imageLink,
    this.pdfLink,
    this.date,
  }) : super(key: key);

  final ThemeData theme;
  final String id;
  final String title;
  final String imageLink;
  final String pdfLink;
  final String date;
  final String content;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return pdfPage(title: title, pdfLink: pdfLink);
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Wrap(
                children: <Widget>[
                  Container(
                    child: Card(
                      elevation: 4,
                      color: theme.cardColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          height: 150,
                          width: 500,
                          child: Stack(
                            children: [
                              CachedNetworkImage(
                                imageUrl: imageLink,
                                fit: BoxFit.cover,
                                errorWidget: (context, url, error) => Center(
                                  child: Text("Error: Could not load image"),
                                ),
                                height: 150,
                                width: 500,
                              ),
                              BackdropFilter(
                                filter: ImageFilter.blur(
                                  sigmaX: 7,
                                  sigmaY: 7,
                                ),
                                child: Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.1),
                                  ),
                                ),
                              ),
                              Wrap(
                                direction: Axis.vertical,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        16, 16, 16, 4),
                                    child: Text(
                                      title,
                                      style: theme.textTheme.headline3.copyWith(
                                        color: Colors.white,
                                        fontSize: 24,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(
                                      "Published on: " + date,
                                      style: theme.textTheme.bodyText1.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16.0),
                                    child: Text(
                                      content,
                                      style: theme.textTheme.bodyText1.copyWith(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
