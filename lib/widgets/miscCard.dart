import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:flutter/material.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/themes.dart';
import 'package:provider/provider.dart';

class MiscCardSquare extends StatefulWidget {

  const MiscCardSquare({
    Key key,
    @required this.themeToggle,
    @required this.icon,
    @required this.title,
    this.onTap,
  });

  final bool themeToggle;
  final Icon icon;
  final String title;
  final GestureTapCallback onTap;

  static double heightFactor = 8.94;
  static double widthFactor = 4.31;

  @override
  _MiscCardSquareState createState() => _MiscCardSquareState();
}

class _MiscCardSquareState extends State<MiscCardSquare> with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _controller;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: Duration(
        milliseconds: 100,
      ),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }



  @override
  Widget build(BuildContext context) {
    _scale = 1 - _controller.value;
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: widget.onTap,
      onTapUp: _tapUp,
      onTapDown: _tapDown,
      child: Transform.scale(
        scale: _scale,
        child: Card(
          color: darkMode ? Color(0xFF2F2F34) : Colors.black.withOpacity(0.03),
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: 1,
              color: darkMode ? Colors.white.withOpacity(0.1) : Colors.black.withOpacity(0.2),
            ),
            borderRadius: BorderRadius.circular(10.0),
          ),
          semanticContainer: true,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Container(
            height: Scaler.scaleWidgetHeight(115.0, MiscCardSquare.heightFactor),
            width: Scaler.scaleWidgetHeight(115.0, MiscCardSquare.heightFactor),
            child: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: widget.icon,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      widget.title,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.headline3.copyWith(
                        fontFamily: "Gilroy-Bold",
                        letterSpacing: 0.9,
                        fontSize: Scaler.scaleWidgetWidth(14.0, MiscCardSquare.widthFactor),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          elevation: 0,
          margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
        ),
      ),
    );
  }

  void _tapDown(TapDownDetails details) {
    // _controller.forward();
  }
  void _tapUp(TapUpDetails details) {
    // _controller.reverse();
  }
}



class MiscCard extends StatelessWidget {
  const MiscCard({
    Key key,
    @required this.themeToggle,
    @required this.icon,
    @required this.title,
    @required this.width,
    @required this.height,
    this.onTap,
  });

  final bool themeToggle;
  final Icon icon;
  final String title;
  final double width;
  final double height;
  final GestureTapCallback onTap;

  static double heightFactor = 8.94;
  static double widthFactor = 4.31;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: AppTheme.mitPostOrange.withOpacity(0.5),
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        child: Container(
          height: Scaler.scaleWidgetHeight(height, heightFactor),
          width: Scaler.scaleWidgetHeight(width, heightFactor),
          child: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: icon,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    title,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.headline3.copyWith(
                      fontSize: Scaler.scaleWidgetWidth(16.0, widthFactor),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      ),
    );
  }
}
