import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mit_post/screens/SLCMRoot.dart';
import 'package:mit_post/screens/articlesPage.dart';
import 'package:mit_post/screens/eventsPage.dart';
import 'package:mit_post/screens/noticesPage.dart';
import 'package:mit_post/screens/socialPage.dart';
import 'package:dynamic_scaler/dynamic_scaler.dart';
import '../util/strings.dart';
import '../util/themes.dart';

class RootPage extends StatefulWidget {
  final selectedPageIndex;
  const RootPage({this.selectedPageIndex});
  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {

  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  int _selectedPage = 0;
  List<Widget> pageList;
  PageController _pageController;

  @override
  void initState() {
    super.initState();
    _selectedPage = widget.selectedPageIndex == null ? 0 : widget.selectedPageIndex;
    pageList = [
      ArticlesPage(),
      SocialPage(),
      SLCMRoot(),
      EventsPage(),
      NoticesPage(),
    ];

    _pageController = PageController(initialPage: _selectedPage);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  static double heightFactor = 8.94;
  static double widthFactor = 4.31;
  double iconSize = Scaler.scaleWidgetWidth(26, widthFactor);
  double selectedIconSize = Scaler.scaleWidgetWidth(30, widthFactor);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        key: scaffoldStateKey,
        body: PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: pageList,
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          type: BottomNavigationBarType.fixed,
          currentIndex: _selectedPage,
          selectedLabelStyle: TextStyle(
              fontSize: Scaler.scaleWidgetWidth(15, widthFactor),
              fontFamily: bold),
          unselectedLabelStyle: TextStyle(
              fontSize: Scaler.scaleWidgetWidth(12, widthFactor),
              fontFamily: medium),
          selectedItemColor: AppTheme.mitPostOrange,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: _selectedPage == 0
                  ? Icon(
                      Icons.text_snippet,
                      size: selectedIconSize,
                    )
                  : Icon(
                      Icons.text_snippet_outlined,
                      size: iconSize,
                    ),
              label: articles,
            ),
            BottomNavigationBarItem(
              icon: _selectedPage == 1
                  ? Icon(
                      Icons.favorite,
                      size: selectedIconSize,
                    )
                  : Icon(
                      Icons.favorite_border_outlined,
                      size: iconSize,
                    ),
              label: social,
            ),
            BottomNavigationBarItem(
              icon: _selectedPage == 2
                  ? Icon(
                      Icons.person,
                      size: selectedIconSize,
                    )
                  : Icon(
                      Icons.person_outline,
                      size: iconSize,
                    ),
              label: "SLCM",
            ),
            BottomNavigationBarItem(
              icon: _selectedPage == 3
                  ? Icon(
                      Icons.event_note,
                      size: selectedIconSize,
                    )
                  : Icon(
                      Icons.event_note_outlined,
                      size: iconSize,
                    ),
              label: events,
            ),
            BottomNavigationBarItem(
              icon: _selectedPage == 4
                  ? Icon(
                      Icons.notifications,
                      size: selectedIconSize,
                    )
                  : Icon(
                      Icons.notifications_outlined,
                      size: iconSize,
                    ),
              label: notices,
            ),

            /// !!! v3.0.0
            /// Shifted to appbar -> Violated Material UI Guidelines
            /// > Do not set more than 5 elements in bottom navbar.
            // BottomNavigationBarItem(
            //   icon: Icon(
            //     Icons.view_quilt,
            //     size: iconSize,
            //   ),
            //   label: misc,
            // ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedPage = index;

      /// TODO: Animations for page switching
      _pageController.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.decelerate);
    });
  }
}
