import 'package:cached_network_image/cached_network_image.dart';
import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/style.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:html/parser.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/strings.dart';
import 'package:mit_post/util/themes.dart';
import 'package:provider/provider.dart';
import 'package:transparent_image/transparent_image.dart';
import '../screens/articlesDetailPage.dart';
import 'package:flutter_html/flutter_html.dart';

class ArticleCard extends StatelessWidget {
  const ArticleCard({
    Key key,
    @required this.theme,
    this.id,
    this.author,
    this.date,
    this.description,
    this.title,
    this.imageUrl,
    this.link,
  }) : super(key: key);

  final int id;
  final ThemeData theme;
  final String title;
  final String date;
  final String description;
  final String author;
  final String imageUrl;
  final String link;

  final double heightFactor = 8.94;
  final double widthFactor = 4.31;

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return ArticleDetailPage(
                id: id,
                title: title,
                author: author,
                link: link,
              );
            },
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: Wrap(
                children: <Widget>[
                  Container(
                    child: Card(
                      elevation: 0,
                      color: theme.cardColor,
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          width: 1.25,
                          color: darkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.08),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Column(
                          children: <Widget>[
                            CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => Center(
                                child: Text("Error: Could not load image"),
                              ),
                              height:
                                  Scaler.scaleWidgetHeight(200, heightFactor),
                              width: Scaler.scaleWidgetWidth(500, widthFactor),
                            ),
//                            FadeInImage.memoryNetwork(
//                              height: 180,
//                              width: 500,
//                              placeholder: kTransparentImage,
//                              image: imageUrl,
//                              fit: BoxFit.fitWidth,
//                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  parse(parse(title).body.text)
                                      .documentElement
                                      .text,
                                  style: theme.textTheme.headline2.copyWith(
                                    fontSize: Scaler.scaleWidgetWidth(
                                        18, widthFactor),),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(8, 8, 8, 2),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 0, horizontal: 10.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                2,
                                        child: Text(
                                          parse(parse(author).body.text).documentElement.text,
                                          style: theme.textTheme.bodyText2
                                              .copyWith(
                                            fontSize: Scaler.scaleWidgetWidth(
                                                13, widthFactor),),
                                          overflow: TextOverflow.fade,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text(
                                        date,
                                        style: theme.textTheme.bodyText2
                                            .copyWith(
                                          fontSize: Scaler.scaleWidgetWidth(
                                              13, widthFactor),),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 8.0,
                                right: 8,
                                left: 8,
                              ),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Html(
                                  data: description,
                                  style: {
                                    "body": Style(
                                      fontSize: FontSize(
                                        Scaler.scaleWidgetWidth(
                                            14, widthFactor),),
                                      color: theme.colorScheme.secondary,
                                      fontFamily: medium,
                                      textAlign: TextAlign.justify,
                                    ),
                                  },
                                ),
                              ),
                            ),
                          ],
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
