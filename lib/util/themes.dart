import 'package:flutter/material.dart';
import 'package:mit_post/util/strings.dart';
import 'strings.dart';

class AppTheme {
  AppTheme._();

  static Color mitPostOrange = Color(0xFFF16739);
  static Color blueWhite = Color(0xFFEFF0F5);
  static Color black = Colors.black54;
  static Color pitchBlack = Colors.black;
  static Color white = Colors.white;
  static Color offWhite = Colors.white70;

  ///Light Theme
  static final ThemeData light = ThemeData(
    scaffoldBackgroundColor: blueWhite,
    accentColor: mitPostOrange,
    appBarTheme: AppBarTheme(
      color: mitPostOrange,
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
    ),
    textTheme: lightTextTheme,
    cardColor: white,
    colorScheme: ColorScheme.light(
      primary: white,
      primaryVariant: Colors.black,
      secondary: Colors.black54,
      secondaryVariant: Color(0xFFC9DAE7),
    ),
  );

  static final TextTheme lightTextTheme = TextTheme(
    headline1: lightTextStylePageHeading, //Article Title
    headline2: lightTextStyleTitle,
    headline3: lightTextStyleSectionTitle, //Article Title
    bodyText1: lightTextStyleExcerpts, //Excerpt
    bodyText2: lightTextStyleAuthorName, //Authors and Time
  );

  static final TextStyle lightTextStylePageHeading = TextStyle(
    fontSize: 38,
    fontFamily: medium,
    color: AppTheme.mitPostOrange,
  );

  static final TextStyle lightTextStyleTitle = TextStyle(
    color: Colors.black,
    fontSize: 18,
    fontFamily: medium,
  );

  static final TextStyle lightTextStyleSectionTitle = TextStyle(
    fontSize: 26,
    fontFamily: bold,
    color: Colors.black,
  );

  static final TextStyle lightTextStyleAuthorName = TextStyle(
    color: Colors.black38,
    fontSize: 14,
    fontFamily: mediumItalic,
  );

  static final TextStyle lightTextStyleExcerpts = TextStyle(
    color: Colors.black,
    fontSize: 14,
    fontFamily: medium,
  );

  ///Dark Theme
  static final ThemeData dark = ThemeData(
    scaffoldBackgroundColor: Color(0xFF17181C),
    accentColor: mitPostOrange,
    appBarTheme: AppBarTheme(
      color: mitPostOrange,
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
    ),
    textTheme: darkTextTheme,
    cardColor: Color(0xFF1F1F24),
    colorScheme: ColorScheme.dark(
      primary: white,
      primaryVariant: Colors.white,
      secondary: Colors.white70,
      secondaryVariant: Color(0xFF17181C),
    ),
  );

  static final TextTheme darkTextTheme = TextTheme(
    headline1: darkTextStylePageHeading,
    headline2: darkTextStyleTitle, //Article Title
    headline3: darkTextStyleSectionTitle, //Social Section Title
    bodyText1: darkTextStyleExcerpts, //Excerpt
    bodyText2: darkTextStyleAuthorName, //Authors and Time
  );

  static final TextStyle darkTextStylePageHeading = TextStyle(
    fontSize: 38,
    fontFamily: medium,
    color: AppTheme.mitPostOrange,
  );

  static final TextStyle darkTextStyleTitle = TextStyle(
    color: Colors.white,
    fontSize: 18,
    fontFamily: medium,
  );

  static final TextStyle darkTextStyleSectionTitle = TextStyle(
    fontSize: 26,
    fontFamily: bold,
    color: Colors.white,
  );

  static final TextStyle darkTextStyleAuthorName = TextStyle(
    color: Colors.white70,
    fontSize: 14,
    fontFamily: mediumItalic,
  );

  static final TextStyle darkTextStyleExcerpts = TextStyle(
    color: Colors.white,
    fontSize: 14,
    fontFamily: medium,
  );
}
