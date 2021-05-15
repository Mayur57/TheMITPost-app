import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mit_post/util/state.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:math';

class ContactCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    return Card(
      margin: EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 1,
          color: darkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: darkMode ? Color(0xFF2F2F34) : Colors.black.withOpacity(0.03),
      elevation: 0,
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Transform.rotate(
                  angle: 3 * pi / 4,
                  child: IconButton(
                    tooltip: "Our Website",
                      icon: Icon(
                        Icons.arrow_back_sharp,
                        color: darkMode ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
                        size: 28,
                      ),
                      onPressed: () async {
                        var url =
                            "https://themitpost.com";
                        if (await canLaunch(url)) {
                          await launch(url);
                        } else {
                          throw 'Could not launch $url';
                        }
                      }),
                ),
                IconButton(
                  tooltip: "Instagram",
                    icon: Icon(
                      FontAwesomeIcons.instagram,
                      color: darkMode ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
                      size: 28,
                    ),
                    onPressed: () async {
                      var url =
                          "https://www.instagram.com/themitpost/";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }),
                IconButton(
                  tooltip: "Twitter",
                    icon: Icon(
                      FontAwesomeIcons.twitter,
                      color: darkMode ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
                      size: 28,
                    ),
                    onPressed: () async {
                      var url =
                          "https://twitter.com/themitpost";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }),
                IconButton(
                  tooltip: "Facebook",
                    icon: Icon(
                      FontAwesomeIcons.facebook,
                      color: darkMode ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
                      size: 28,
                    ),
                    onPressed: () async {
                      var url =
                          "https://www.facebook.com/themitpost/";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }),
                IconButton(
                    icon: Icon(
                      FontAwesomeIcons.linkedin,
                      color: darkMode ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
                      size: 28,
                    ),
                    onPressed: () async {
                      var url =
                          "https://www.linkedin.com/company/13329757/admin/";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }),
              ],
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
