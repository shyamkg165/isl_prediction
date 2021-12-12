import 'package:flutter/material.dart';
import '/display/match_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/constants.dart';

final _firestore = FirebaseFirestore.instance;

List<MatchDisplay> matches = [];

class PredictionsPage extends StatefulWidget {
  @override
  _PredictionsPageState createState() => _PredictionsPageState();
}

class _PredictionsPageState extends State<PredictionsPage> {
  @override
  void initState() {
    updateMatchSchedule();
    super.initState();
  }

  void updateMatchSchedule() async {
    print('in update match schedule\n');
    final matchSchedule = await _firestore.collection('matchschedule').get();
    matches.clear();
    print('size');
    print(matchSchedule.size);
    for (var match in matchSchedule.docs) {
      final int matchNum = match.data()['matchnum'];
      final String firstTeam = match.data()['firstteam'];
      final String secondTeam = match.data()['secondteam'];
      final String firstImg = match.data()['firstimg'];
      final String secondImg = match.data()['secondimg'];
      final Timestamp matchTime = match.data()['matchtime'];
      final String matchStatus = match.data()['matchstatus'];

      final String cutOffTime = readTimestamp(matchTime);

      String firstButtonName = 'PREDICT NOW';
      String secondButtonName = 'NA';

      if (cutOffTime != 'Time ended') {
        firstButtonName = 'PREDICT NOW';
        secondButtonName = 'NA';
      } else if ((cutOffTime == 'Time ended') && (matchStatus != 'completed')) {
        firstButtonName = 'SHOW PREDICTIONS';
        secondButtonName = 'NA';
      } else if ((cutOffTime == 'Time ended') && (matchStatus == 'completed')) {
        firstButtonName = 'SHOW PREDICTIONS';
        secondButtonName = 'SHOW RESULTS';
      }

      final matchDisplay = MatchDisplay(
        matchNum: matchNum,
        firstTeam: firstTeam,
        secondTeam: secondTeam,
        firstImg: firstImg,
        secondImg: secondImg,
        matchStatus: matchStatus,
        cutOffTime: cutOffTime,
        firstButtonName: firstButtonName,
        secondButtonName: secondButtonName,
      );
      matches.add(matchDisplay);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(klogoPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemCount: matches.length,
              /*separatorBuilder: (BuildContext context, int index) {
                return SizedBox(height: 10);
              },*/
              itemBuilder: (context, index) {
                print('inpredictions' + matches[index].matchNum.toString());
                return FittedBox(
                  fit: BoxFit.fitWidth,
                  child: MatchDisplay(
                    matchNum: matches[index].matchNum,
                    firstTeam: matches[index].firstTeam,
                    secondTeam: matches[index].secondTeam,
                    firstImg: matches[index].firstImg,
                    secondImg: matches[index].secondImg,
                    cutOffTime: matches[index].cutOffTime,
                    firstButtonName: matches[index].firstButtonName,
                    secondButtonName: matches[index].secondButtonName,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

String readTimestamp(Timestamp t) {
  int timestamp = t.microsecondsSinceEpoch;
  var now = DateTime.now();
  var date = DateTime.fromMicrosecondsSinceEpoch(timestamp);
  var diff = date.difference(now);
  var time = '';

  int remInHours = diff.inHours - (24 * diff.inDays);
  int remInMins = diff.inMinutes - (60 * diff.inHours);

  if (diff.inSeconds <= 0) {
    time = 'Time ended';
    return time;
  }
  if (diff.inSeconds > 0 && diff.inMinutes == 0 ||
      diff.inMinutes > 0 && diff.inHours == 0) {
    time = diff.inMinutes.toString() + ' MINUTES';
    return time;
  }
  if (diff.inHours > 0 && diff.inDays == 0) {
    time =
        remInHours.toString() + ' HOURS ' + remInMins.toString() + ' MINUTES';
    return time;
  } else {
    if (diff.inDays == 1) {
      time = diff.inDays.toString() +
          ' DAY ' +
          remInHours.toString() +
          ' HOURS ' +
          remInMins.toString() +
          ' MINUTES';
    } else {
      time = diff.inDays.toString() +
          ' DAYS ' +
          remInHours.toString() +
          ' HOURS ' +
          remInMins.toString() +
          ' MINUTES';
    }
  }
  return time;
}
