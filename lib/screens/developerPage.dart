import 'package:flutter/material.dart';
import 'package:mit_post/util/strings.dart';
import 'package:mit_post/widgets/devCard.dart';
import 'package:dynamic_scaler/dynamic_scaler.dart';

class DeveloperPage extends StatelessWidget {
  final double heightFactor = 8.94;
  final double widthFactor = 4.31;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: Scaler.scaleWidgetWidth(4.0, widthFactor)),
          child: SafeArea(
            child: Column(
              children: <Widget>[
                Align(alignment: Alignment.centerLeft,child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(icon: Icon(Icons.arrow_back), onPressed: (){Navigator.pop(context);}),
                )),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: Scaler.scaleWidgetWidth(10.0, widthFactor),
                      bottom: Scaler.scaleWidgetHeight(4.0, heightFactor),
                      left: Scaler.scaleWidgetWidth(10.0, widthFactor),
                      top: Scaler.scaleWidgetHeight(20.0, heightFactor),
                    ),
                    child: Text(
                      "Application Developers",
                      style: theme.textTheme.headline3.copyWith(
                        fontSize: Scaler.scaleWidgetWidth(26, widthFactor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: Scaler.scaleWidgetWidth(10.0, widthFactor),
                    bottom: Scaler.scaleWidgetHeight(14.0, heightFactor),
                    left: Scaler.scaleWidgetWidth(10.0, widthFactor),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Developers of The MIT Post app",
                      style: theme.textTheme.bodyText1.copyWith(
                        fontSize: Scaler.scaleWidgetWidth(16, widthFactor),
                      ),
                    ),
                  ),
                ),
                DeveloperCard(
                  avatar: avatarMayur,
                  name: "Mayur Bhoi",
                  position: "Flutter and UI/UX",
                  instagram: instagramMayur,
                  linkedin: linkedinMayur,
                  github: githubMayur,
                ),
                DeveloperCard(
                  avatar: avatarMidhun,
                  name: "Midhun Pramod",
                  position: "Backend and Flutter",
                  instagram: instagramMidhun,
                  linkedin: linkedinMidhun,
                  github: githubMidhun,
                ),
                DeveloperCard(
                  avatar: avatarSanskaar,
                  name: "Sanskaar Patni",
                  position: "DevOps and Flutter",
                  instagram: instagramSanskaar,
                  linkedin: linkedinSanskaar,
                  github: githubSanskaar,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: Scaler.scaleWidgetWidth(10.0, widthFactor),
                      bottom: Scaler.scaleWidgetHeight(4.0, heightFactor),
                      left: Scaler.scaleWidgetWidth(10.0, widthFactor),
                      top: Scaler.scaleWidgetHeight(20.0, heightFactor),
                    ),
                    child: Text(
                      "Legacy Developers",
                      style: theme.textTheme.headline3.copyWith(
                        fontSize: Scaler.scaleWidgetWidth(26, widthFactor),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                    right: Scaler.scaleWidgetWidth(10.0, widthFactor),
                    bottom: Scaler.scaleWidgetHeight(14.0, heightFactor),
                    left: Scaler.scaleWidgetWidth(10.0, widthFactor),
                  ),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "The developers who started it all. The developers of legacy apps that preceded the Flutter version.",
                      style: theme.textTheme.bodyText1.copyWith(
                        fontSize: Scaler.scaleWidgetWidth(16, widthFactor),
                      ),
                    ),
                  ),
                ),
                DeveloperCard(
                  avatar: avatarRakshit,
                  name: "Rakshit GL",
                  position: "Android Developer",
                  instagram: instagramRakshit,
                  linkedin: linkedinRakshit,
                  github: githubRakshit,
                ),
                DeveloperCard(
                  avatar: avatarHarshaVardhan,
                  name: "HarshaVardhan K",
                  position: "Backend & iOS Developer",
                  instagram: instagramHarshaVardhan,
                  linkedin: linkedinHarshaVardhan,
                  github: githubHarshaVardhan,
                ),
                SizedBox(
                  height: Scaler.scaleWidgetHeight(50, heightFactor),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
