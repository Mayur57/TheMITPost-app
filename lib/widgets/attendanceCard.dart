import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/strings.dart';
import 'package:mit_post/util/themes.dart';
import 'package:provider/provider.dart';

class AttendanceCard extends StatefulWidget {
  const AttendanceCard({
    Key key,
    @required this.subject,
    @required this.code,
    @required this.totalClasses,
    @required this.classesPresent,
    @required this.classesAbsent,
    @required this.attendancePercentage,
    @required this.index,
    @required this.onTap,
  });

  final String subject;
  final String code;
  final String totalClasses;
  final String classesPresent;
  final String classesAbsent;
  final String attendancePercentage;
  final int index;
  final GestureTapCallback onTap;

  @override
  _AttendanceCardState createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard> {
  final double heightFactor = 8.94;
  final double widthFactor = 4.31;

  bool cardState = true;

  ///true means show attendance
  double _stackHeight = 200;

  Color _attendanceColor(String attendance) {
    double perc = double.parse(attendance);
    if (perc < 75.00) {
      return Colors.redAccent;
    } else if (perc < 85.00 && perc > 75.00) {
      return Colors.amber;
    } else
      return Colors.white;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          attendanceCard(theme, darkMode, cardState),
        ],
      ),
    );
  }

  attendanceCard(ThemeData theme, bool darkMode, bool cardState) {
    double attendanceN = double.parse(widget.classesPresent) /
        double.parse(widget.totalClasses) *
        100;
    String attendance = attendanceN.toStringAsFixed(2);
    return Card(
      elevation: 4,
      color: theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(16)),
      ),
      child: ClipRRect(
        clipBehavior: Clip.antiAlias,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: Scaler.scaleWidgetHeight(207, heightFactor),
          width: Scaler.scaleWidgetWidth(500, widthFactor),
          child: Stack(
            children: [
              GestureDetector(
                onTap: widget.onTap,
                child: Image.asset(
                  images[widget.index % 8],
                  fit: BoxFit.cover,
                  height: Scaler.scaleWidgetHeight(210, heightFactor),
                  width: Scaler.scaleWidgetWidth(500, widthFactor),
                  color: Colors.black.withOpacity(0.45),
                  colorBlendMode: BlendMode.darken,
                ),
              ),
              GestureDetector(
                onTap: widget.onTap,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Wrap(
                    direction: Axis.vertical,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width - 120,
                            child: Text(
                              widget.subject.toString().length < 45
                                  ? widget.subject
                                  : widget.subject.toString().substring(0, 45) +
                                      "...",
                              style: theme.textTheme.headline3.copyWith(
                                fontSize:
                                    Scaler.scaleWidgetWidth(20, widthFactor),
                                color: Colors.white,
                              ),
                              softWrap: true,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            widget.code,
                            style: theme.textTheme.bodyText1.copyWith(
                              color: Colors.white,
                              fontSize: Scaler.scaleWidgetWidth(14, widthFactor),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Total Classes: ' +
                                    widget.totalClasses.toString().trim(),
                                style: theme.textTheme.bodyText1.copyWith(
                                  color: Colors.white,
                                  fontSize:
                                      Scaler.scaleWidgetWidth(14, widthFactor),
                                ),
                              ),
                              Text(
                                'Classes Absent: ' +
                                    widget.classesAbsent.toString().trim(),
                                style: theme.textTheme.bodyText1.copyWith(
                                  color: Colors.white,
                                  fontSize:
                                      Scaler.scaleWidgetWidth(14, widthFactor),
                                ),
                              ),
                              Text(
                                'Classes Present: ' + widget.classesPresent,
                                style: theme.textTheme.bodyText1.copyWith(
                                  color: Colors.white,
                                  fontSize:
                                      Scaler.scaleWidgetWidth(14, widthFactor),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                child: _attendanceParser(widget.classesPresent, widget.totalClasses) == "PNYA" ? Text(
                  'Attendance not  \nuploaded yet  ',
                  style: theme.textTheme.headline3.copyWith(
                    color: _attendanceColor(
                      widget.attendancePercentage,
                    ),
                    fontSize: Scaler.scaleWidgetWidth(12, widthFactor),
                    fontFamily: medium,
                  ),
                  textAlign: TextAlign.center,
                ) : Text(
                  _attendanceParser(widget.classesPresent, widget.totalClasses),
                  style: theme.textTheme.headline3.copyWith(
                    color: _attendanceColor(
                      widget.attendancePercentage,
                    ),
                    fontSize: Scaler.scaleWidgetWidth(30, widthFactor),
                  ),
                ),
                right: 10,
                bottom: 10,
              ),
              Positioned(
                child: Row(
                  children: [
                    widget.subject.toString().contains('Lab') ||
                            widget.subject.toString().contains('Workshop')
                        ? GestureDetector(
                            child: Icon(
                              FontAwesomeIcons.flask,
                              size: Scaler.scaleWidgetWidth(20, widthFactor),
                              color: Colors.white,
                            ),
                            onTap: () {
                              Fluttertoast.showToast(
                                msg:
                                    "Note: This is a lab subject and hence the attendance percentage changes rapidly.",
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG,
                              );
                            },
                          )
                        : Container(),
                    SizedBox(
                      width: Scaler.scaleWidgetWidth(10, widthFactor),
                    ),
                    double.parse(widget.attendancePercentage) < 75.0 && widget.totalClasses != "0"
                        ? GestureDetector(
                            child: Icon(
                              FontAwesomeIcons.exclamationCircle,
                              size: Scaler.scaleWidgetWidth(20, widthFactor),
                              color: Colors.white,
                            ),
                            onTap: () {
                              Fluttertoast.showToast(
                                msg:
                                    "Caution: Your attendance is lower than the safe threshold of 75%",
                                gravity: ToastGravity.BOTTOM,
                                toastLength: Toast.LENGTH_LONG,
                              );
                            },
                          )
                        : Container(),
                  ],
                ),
                right: 15,
                top: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<String> images = [
    p1,p2,p3,p4,p5,p6,p7,p8,
  ];

  // String _slcmCardImage(int index) {
  //   return images[index];
  // }

  _attendanceParser(String classesPresent, String totalClasses) {
    if (int.parse(totalClasses) != 0) {
      double attendanceN =
          double.parse(classesPresent) / double.parse(totalClasses) * 100;
      String attendance = attendanceN.toStringAsFixed(2);
      return attendance == "100.00" ? "100%" : attendance + "%";
    } else {
      return "PNYA";
    }
  }
}
