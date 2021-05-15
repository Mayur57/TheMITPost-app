import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/strings.dart';
import 'package:mit_post/widgets/contactsCard.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutUsPage extends StatelessWidget {
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
                  "About Us",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primaryVariant,
                    fontSize: 38,
                    fontFamily: "Gilroy-Bold",
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                ContactCard(),
                SizedBox(
                  height: 15,
                ),
                Card(
                  margin: EdgeInsets.all(0),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1,
                      color: darkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  color: darkMode ? Color(0xFF2F2F34) : Colors.black.withOpacity(0.03),
                  elevation: 0,
                  child: InkWell(
                    onTap: () async {
                      var url =
                          "https://www.themitpost.com/";
                      if (await canLaunch(url)) {
                        await launch(url);
                      } else {
                        throw 'Could not launch $url';
                      }
                    },
                    child: Container(
                      width: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "VISIT OUR WEBSITE",
                            style: TextStyle(
                              fontFamily: "Gilroy",
                              letterSpacing: 1.25,
                              color: darkMode ? Colors.white.withOpacity(0.5) : Colors.black.withOpacity(0.8),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  about,
                  style: TextStyle(
                    fontFamily: "Gilroy",
                    color: darkMode ? Colors.white.withOpacity(0.6) : Colors.black.withOpacity(0.6),
                  ),
                ),
                SizedBox(
                  height: 15,
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
