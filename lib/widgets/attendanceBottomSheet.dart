import 'package:dynamic_scaler/dynamic_scaler.dart';
import 'package:flutter/material.dart';
import 'package:mit_post/util/constants.dart';
import 'package:mit_post/util/state.dart';
import 'package:mit_post/util/strings.dart';
import 'package:mit_post/util/themes.dart';
import 'package:provider/provider.dart';

class AttendanceBottomSheet extends StatelessWidget {
  AttendanceBottomSheet({@required this.snapshot, @required this.index});

  final AsyncSnapshot<dynamic> snapshot;
  final int index;

  @override
  Widget build(BuildContext context) {
    bool darkMode = Provider.of<AppThemeStateNotifier>(context).isDarkMode;
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 22, right: 22, left: 22, bottom: 16),
              child: Text(
                _formatSubject(snapshot.data.attendance[index].subject),
                style: Theme.of(context).textTheme.headline3,
              ),
            ),
          ),

          ///Attendance Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
                  child: Text(
                    "Attendance",
                    style: TextStyle(
                      fontFamily: bold,
                      fontSize: 20,
                      color: darkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 22),
                  child: Text(
                    "o",
                    style: TextStyle(
                      fontFamily: bold,
                      fontSize: 20,
                      color: darkMode ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 22.0, bottom: 8),
              child: Container(
                height: Scaler.scaleWidgetHeight(2, heightFactor),
                width: Scaler.scaleWidgetWidth(35, widthFactor),
                color: AppTheme.mitPostOrange,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Classes",
                  style: TextStyle(
                    fontFamily: medium,
                    fontSize: 16,
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  snapshot.data.attendance[index].totalClass,
                  style: TextStyle(
                    fontFamily: medium,
                    fontSize: 16,
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Classes Attended",
                  style: TextStyle(
                    fontFamily: medium,
                    fontSize: 16,
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  snapshot.data.attendance[index].daysPresent,
                  style: TextStyle(
                    fontFamily: medium,
                    fontSize: 16,
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22.0, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Total Absent",
                  style: TextStyle(
                    fontFamily: medium,
                    fontSize: 16,
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                ),
                Text(
                  snapshot.data.attendance[index].daysAbsent,
                  style: TextStyle(
                    fontFamily: medium,
                    fontSize: 16,
                    color: darkMode ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.warning),
              Column(
                children: [
                  Text("You need to attend next 32 classes",
                      style: TextStyle(fontFamily: bold)),
                ],
              ),
            ],
          ),

          predictorWidget(predictPresentStreak(
              snapshot.data.attendance[index].totalClass,
              snapshot.data.attendance[index].daysPresent)),
        ],
      ),
    );
  }
}

List<String> ROMANS = [
  'I',
  'II',
  'III',
  'IV',
  'V',
  'VI',
  'VII',
  'VIII',
  'IX',
  'X'
];

String _formatSubject(String subject) {
  final splitName = subject.split(" ");
  String returnName = "";
  for (int i = 0; i < splitName.length; i++) {
    if (ROMANS.contains(splitName[i])) {
      returnName = returnName + " " + splitName[i];
      break;
    }
    if (splitName[i] != 'OF' && splitName[i] != 'AND') {
      returnName = returnName +
          " " +
          splitName[i][0] +
          splitName[i].substring(1).toLowerCase();
    } else {
      returnName = returnName + " " + splitName[i].toLowerCase();
    }
  }
  return returnName.trim();
}

returnAttendanceModalSheet(context, snapshot, index) {
  return showModalBottomSheet(
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.0),
          topRight: Radius.circular(16.0),
        ),
      ),
      backgroundColor: Theme.of(context).cardColor,
      context: context,
      builder: (context) {
        return AttendanceBottomSheet(snapshot:snapshot, index: null);
      });
}

Widget predictorWidget(int x){
  switch(x) {
    case 0:
      return Container(
          height: 100,
          width: 100,
          color: Colors.red
      );
    case -1:
      return Container(
          height: 100,
          width: 100,
          color: Colors.blue
      );
    default:
      return Container(
          height: 100,
          width: 100,
          color: Colors.green
      );
  }
}
