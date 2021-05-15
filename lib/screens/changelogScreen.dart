import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mit_post/util/strings.dart';

class ChangelogScreen extends StatelessWidget {
  final controller = ScrollController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Markdown(data: _mdData, controller: controller,),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.arrow_upward),
          onPressed: () => controller.animateTo(0,
              duration: Duration(milliseconds: 500), curve: Curves.easeInOut),
        ),
      ),
    );
  }
}

String _mdData = """
![changelog.png](https://github.com/themitpost/themitpost-documentation/blob/main/theapp/cl-app.png?raw=true)


# Official Changelog
This is a collection of changelogs for [The MIT Post app](https://play.google.com/store/apps/details?id=com.thepost.app).

## v3.0.5 (17-02-2021)
**Fixes and Improvements**
- Fixed: Incorrect scaling for SLCM attendance cards on 16:9 and lower DPI screens
- Fixed: Subject name containing roman numerals parsed incorrectly
- Fixed: The justification of article body was buggy and has been fixed with proper rendering
- Fixed: Cards won't show 0% when no data has been uploaded to the servers and instead will show appropriate warning

## v3.0.4 (27-01-2021)
**Fixes and Improvements**
- Added: Images for attendance cards
- Added: Page changing transitions
- Added: Serialised page loading
- Added: A secret easter egg
- Fixed: Vibration toggle color fixes for light mode
- Improved: Tweet card UI and size
- Improved: Social page scaling fixed
- Improved: Article card design
- Fixed: Typographical errors in Events tab
- Several other fixes and general performance improvements


## v3.0.3 (31-12-2020)
**Fixes and Improvements**
- Added: Support for toggling device-wide vibration
- Fixed: Removing expired events
- Fixed: Debug comments disabled
- Fixed: Incorrect rounding of attendance percentages
- Fixed: Better parameters for Events API sorting algorithm
- Improved attendance fetching algorithm
- Several other fixes and general performance improvements

## v3.0.2 (23-11-2020)
This update fixes some glitches and also rectifies some of the typos:

**Fixes and Improvements**
- Added: Support for variable touch resampling to support high refresh rate displays
- Added: Hardware accelerated UI rendering
- Fixed: 'TechTatva' category was incorrectly named
- Fixed: Long notices now get truncated if found longer than 256 chars
- Fixed: Updated Events API
- Fixed: Typographical errors in Events tab
- Several other fixes and general performance improvements

## v3.0.1 (09-11-2020)
We are always working towards bringing you a seamless experience. This update improves performance and patches many of the bugs involving the SLCM and Notices tab:

**Fixes and Improvements**
- Added: A warning to indicate when SLCM servers are down
- Added: Spam protection for SLCM logins
- Fixed: A bug that showed notices had an attachment regardless of if there were any attachments
- Fixed: Changed the playlist tile from "Playlists By Us" to "Playlists"
- Updated binaries to the latest versions
- Several other fixes and improvements

## v3.0.0 (30-10-2020)
The much awaited [Flutter](https://flutter.dev/) version of our app is here!
This version adds tons of new features and improves performance and smoothness significantly.

**New Features**
- Exclusive: SLCM makes a comeback with superior quality and speed
- Read latest articles by our writers without leaving the app
- Dynamically switching dark mode which is significantly more efficient than the previous implementation
- Support for serif and sans serif fonts for articles with variable font size of choice
- Toggle dark mode while reading the articles
- Our [Instagram](https://www.instagram.com/themitpost/) feed and [Twitter](https://twitter.com/themitpost) timeline built right into the app so that you get to see all our creative content at one place
- Official club events and more with links to register
- Read event reports covered our reporters
- Find all the official notices right in the app and get notified when new notices are released by the college instantly
- Read all the editions of our magazine, [The Standard]()
- Listen to the soothing playlists curated by us while studying
- Academic Calender section to make it easy to find the official calender released by the authorities in just a couple of clicks

We at The MIT Post strive for perfection and high standards of quality. So, in-case you find any issues, please do reach out to our developers!

This changelog is maintained by [Mayur Bhoi](https://mayur57.github.io)

© Copyright 2020 The MIT Post

All rights reserved.
""";
