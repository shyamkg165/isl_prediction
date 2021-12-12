import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/display/completed_match_display.dart';

final _firestore = FirebaseFirestore.instance;

List<CompletedMatchDisplay> matches = [];

class CompletedMatchPage extends StatefulWidget {
  @override
  _CompletedMatchPageState createState() => _CompletedMatchPageState();
}

class _CompletedMatchPageState extends State<CompletedMatchPage> {
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
      //final Timestamp matchTime = match.data()['matchtime'];
      final String matchStatus = match.data()['matchstatus'];

      //final String cutOffTime = readTimestamp(matchTime);
      //final String buttonName = getButtonName(cutOffTime, matchStatus);
      if (matchStatus == 'completed') {
        final completedMatchDisplay = CompletedMatchDisplay(
            matchNum: matchNum,
            firstTeam: firstTeam,
            secondTeam: secondTeam,
            firstImg: firstImg,
            secondImg: secondImg,
            matchStatus: matchStatus);

        matches.add(completedMatchDisplay);
      }
    }
    setState(() {});
  }

  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Container(
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
                  child: CompletedMatchDisplay(
                    matchNum: matches[index].matchNum,
                    firstTeam: matches[index].firstTeam,
                    secondTeam: matches[index].secondTeam,
                    firstImg: matches[index].firstImg,
                    secondImg: matches[index].secondImg,
                    matchStatus: matches[index].matchStatus,
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
