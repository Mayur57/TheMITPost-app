import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class DeveloperCard extends StatelessWidget {
  const DeveloperCard({
    Key key,
    @required this.name,
    @required this.avatar,
    @required this.position,
    this.instagram,
    this.linkedin,
    this.twitter,
    this.github,
  });

  final String name;
  final String avatar;
  final String position;
  final String instagram;
  final String linkedin;
  final String twitter;
  final String github;

  final double heightFactor = 8.94;
  final double widthFactor = 4.31;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: Scaler.scaleWidgetHeight(4, heightFactor),
        horizontal: Scaler.scaleWidgetWidth(4, widthFactor),
      ),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ClipPath(
          clipper: ShapeBorderClipper(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Wrap(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Container(
                    height: Scaler.scaleWidgetHeight(145, heightFactor),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Image.asset(
                          avatar,
                          fit: BoxFit.fitHeight,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                vertical:
                                    Scaler.scaleWidgetHeight(8, heightFactor),
                                horizontal:
                                    Scaler.scaleWidgetWidth(10, widthFactor),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: <Widget>[
                                  Text(
                                    name,
                                    style: theme.textTheme.headline3.copyWith(
                                      fontSize: Scaler.scaleWidgetWidth(
                                          26, widthFactor),
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                  Text(
                                    position,
                                    style: theme.textTheme.headline2.copyWith(
                                      fontSize: Scaler.scaleWidgetWidth(
                                          16, widthFactor),
                                    ),
                                    textAlign: TextAlign.right,
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.instagram,
                                    color: theme.colorScheme.primaryVariant,
                                    size: Scaler.scaleWidgetWidth(
                                        24, widthFactor),
                                  ),
                                  onPressed: () async {
                                    var url = instagram;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.linkedin,
                                    color: theme.colorScheme.primaryVariant,
                                    size: Scaler.scaleWidgetWidth(
                                        24, widthFactor),
                                  ),
                                  onPressed: () async {
                                    var url = linkedin;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                ),
                                IconButton(
                                  icon: Icon(
                                    FontAwesomeIcons.github,
                                    color: theme.colorScheme.primaryVariant,
                                    size: Scaler.scaleWidgetWidth(
                                        24, widthFactor),
                                  ),
                                  onPressed: () async {
                                    var url = github;
                                    if (await canLaunch(url)) {
                                      await launch(url);
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
