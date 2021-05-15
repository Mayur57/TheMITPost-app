import 'package:flutter/material.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/strings.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).cardColor,
        body: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 25,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: Icon(
                    Icons.arrow_back,
                    color: Theme.of(context).colorScheme.primaryVariant,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  "Privacy Policy",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryVariant,
                    fontSize: 38,
                    fontFamily: "Gilroy-Bold",
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  privacy1,
                  style: TextStyle(
                    fontFamily: "Gilroy",
                    color: darkMode
                        ? Colors.white.withOpacity(0.4)
                        : Colors.black.withOpacity(0.4),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  privacy2,
                  style: TextStyle(
                    fontFamily: "Gilroy",
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Basic Definitions",
                  style: TextStyle(
                    fontFamily: "Gilroy-Bold",
                    fontSize: 20,
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  privacy3,
                  style: TextStyle(
                    fontFamily: "Gilroy",
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Nature of Data Collection and Data Transfer through our Application and Server",
                  style: TextStyle(
                    fontFamily: "Gilroy-Bold",
                    fontSize: 20,
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  privacy4,
                  style: TextStyle(
                    fontFamily: "Gilroy",
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Nature of Data Collected",
                  style: TextStyle(
                    fontFamily: "Gilroy-Bold",
                    fontSize: 20,
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  privacy5,
                  style: TextStyle(
                    fontFamily: "Gilroy",
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Protection against Malicious Attempts",
                  style: TextStyle(
                    fontFamily: "Gilroy-Bold",
                    fontSize: 20,
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  privacy6,
                  style: TextStyle(
                    fontFamily: "Gilroy",
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Our Disclosure of the User Information",
                  style: TextStyle(
                    fontFamily: "Gilroy-Bold",
                    fontSize: 20,
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  privacy7,
                  style: TextStyle(
                    fontFamily: "Gilroy",
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Help and Support",
                  style: TextStyle(
                    fontFamily: "Gilroy-Bold",
                    fontSize: 20,
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  privacy8,
                  style: TextStyle(
                    fontFamily: "Gilroy",
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "User Agreement",
                  style: TextStyle(
                    fontFamily: "Gilroy-Bold",
                    fontSize: 20,
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  privacy9,
                  style: TextStyle(
                    fontFamily: "Gilroy",
                    color: darkMode
                        ? Colors.white.withOpacity(0.6)
                        : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Center(
                  child: Text(
                    "•  •  •",
                    style: TextStyle(
                      fontFamily: "Gilroy",
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: darkMode
                          ? Colors.white.withOpacity(0.1)
                          : Colors.black.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: darkMode
                      ? Color(0xFF2F2F34)
                      : Colors.black.withOpacity(0.03),
                  elevation: 0,
                  child: Container(
                    width: double.infinity,
                    child: Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(
                          "IN CASE OF ANY QUERIES, MAIL TO:",
                          style: TextStyle(
                            fontFamily: "Gilroy",
                            letterSpacing: 1.25,
                            color: darkMode
                                ? Colors.white.withOpacity(0.3)
                                : Colors.black.withOpacity(0.8),
                          ),
                        ),
                      ),
                      Divider(
                        height: 0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var url = "mailto:developers.themitpost@gmail.com";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "THE MIT POST DEVELOPERS",
                              style: TextStyle(
                                fontFamily: "Gilroy",
                                letterSpacing: 1.25,
                                color: darkMode
                                    ? Colors.white.withOpacity(0.5)
                                    : Colors.black.withOpacity(0.8),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var url = "mailto:mayur072000@gmail.com";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "MAYUR BHOI - Application Developer",
                            style: TextStyle(
                              fontFamily: "Gilroy",
                              letterSpacing: 1.25,
                              color: darkMode
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var url =
                              "mailto:midhunstab@gmail.com";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "MIDHUN PRAMOD - Server Developer",
                            style: TextStyle(
                              fontFamily: "Gilroy",
                              letterSpacing: 1.25,
                              color: darkMode
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                      Divider(
                        height: 0,
                      ),
                      GestureDetector(
                        onTap: () async {
                          var url =
                              "mailto:patnisanskaar@gmail.com";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else {
                            throw 'Could not launch $url';
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "SANSKAAR PATNI - Developer Operations",
                            style: TextStyle(
                              fontFamily: "Gilroy",
                              letterSpacing: 1.25,
                              color: darkMode
                                  ? Colors.white.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Image.asset(
                    "assets/images/post_orange_solid.png",
                    width: MediaQuery.of(context).size.width / 10,
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
