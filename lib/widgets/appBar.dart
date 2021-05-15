import 'package:flutter/material.dart';
import 'package:mit_post/util/themes.dart';
import 'package:mit_post/widgets/darkModeAppBarIcon.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  MyAppBar({this.title});
  @override
  Size get preferredSize => const Size.fromHeight(70);
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      titleSpacing: 25,
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0),
          child: IconButton(
              tooltip: "Miscellaneous",
              icon: Icon(
                Icons.dashboard_outlined,
                color: Colors.grey,
              ),
              onPressed: () {
                Navigator.pushNamed(context, "/misc");
              }),
        ),
        // DarkModeIconButton(),
      ],
      flexibleSpace: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 40),
        child: Text(
          title,
          style: theme.textTheme.headline1,
        ),
      ),
      title: Container(),
    );
  }
}


/// TODO (Mayur57 03:29 11-01-2021) -> Collapsible implementation of the app bar
/// Targeted release version: 3.1.0
/// Resource(s) used: https://medium.com/@diegoveloper/flutter-collapsing-toolbar-sliver-app-bar-14b858e87abe

// class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final String title;
//   MyAppBar({this.title});
//   @override
//   Size get preferredSize => const Size.fromHeight(0);
//   @override
//   Widget build(BuildContext context) {
//     ThemeData theme = Theme.of(context);
//     return SliverAppBar(
//       automaticallyImplyLeading: false,
//       expandedHeight: 120.0,
//       floating: true,
//       pinned: true,
//       snap: false,
//       titleSpacing: 0,
//       backgroundColor: theme.scaffoldBackgroundColor,
//       flexibleSpace: FlexibleSpaceBar(
//         centerTitle: false,
//         titlePadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0,),
//         title: Text(
//           title,
//         style: theme.textTheme.headline3.copyWith(
//           fontSize: 24,
//         ),
//         ),
//       ),
//     );
//   }
// }
