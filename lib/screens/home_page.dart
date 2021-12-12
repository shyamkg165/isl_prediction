import 'package:flutter/material.dart';
import '/display/match_display.dart';
import '/screens/predictions_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/constants.dart';

final _firestore = FirebaseFirestore.instance;
final _auth = FirebaseAuth.instance;
User loggedInUser;
int rank = 0;
int points = 0;

int matchNum;
String firstTeam;
String secondTeam;
String firstImg;
String secondImg;
String cutOffTime;
String firstButtonName;
String secondButtonName;

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    getCurrentUser();
    getRankPoints();
    updateNextMatch();
    super.initState();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print("From Home Page " + loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  void getRankPoints() async {
    final standings =
        await _firestore.collection('standings').doc(loggedInUser.email).get();
    if (standings.exists) {
      rank = standings.data()['rank'];
      points = standings.data()['sumOfAllPoints'];
    } else {
      rank = 0;
      points = 0;
    }
    print("getRank $rank $points");
    setState(() {});
  }

  void updateNextMatch() async {
    print('in update next match \n');
    final nextmatch = await _firestore.collection('matchschedule').get();

    for (var match in nextmatch.docs) {
      print("Match Doc ID " + match.id);
      final String matchStatus = match.data()['matchstatus'];

      if (matchStatus == 'scheduled') {
        matchNum = match.data()['matchnum'];
        firstTeam = match.data()['firstteam'];
        secondTeam = match.data()['secondteam'];
        firstImg = match.data()['firstimg'];
        secondImg = match.data()['secondimg'];
        Timestamp matchTime = match.data()['matchtime'];

        cutOffTime = readTimestamp(matchTime);

        firstButtonName = 'PREDICT NOW';
        secondButtonName = 'NA';

        break;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(klogoPath),
          fit: BoxFit.cover,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: HomeDisplay(display: 'RANK \n#', num: rank),
                ),
                Expanded(
                  child: HomeDisplay(display: 'POINTS \n', num: points),
                ),
              ],
            ),
          ),
          Flexible(
            fit: FlexFit.tight,
            child: Container(
              child: FittedBox(
                child: NextMatchDisplay(
                  matchNum: matchNum,
                  firstTeam: firstTeam,
                  secondTeam: secondTeam,
                  firstImg: firstImg,
                  secondImg: secondImg,
                  cutOffTime: cutOffTime,
                  firstButtonName: firstButtonName,
                  secondButtonName: secondButtonName,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeDisplay extends StatelessWidget {
  HomeDisplay({this.display, this.num});
  final String display;
  final int num;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
          color: Color(0xFF1D1E33), borderRadius: BorderRadius.circular(10.0)),
      child: Center(
        child: FittedBox(
          fit: BoxFit.fitWidth,
          child: Text(
            '$display$num',
            style: TextStyle(
              color: Colors.white,
              fontSize: 100.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class NextMatchDisplay extends StatelessWidget {
  NextMatchDisplay(
      {@required this.matchNum,
      @required this.firstTeam,
      @required this.secondTeam,
      @required this.firstImg,
      @required this.secondImg,
      @required this.cutOffTime,
      @required this.firstButtonName,
      this.secondButtonName});

  final int matchNum;
  final String firstTeam;
  final String secondTeam;
  final String firstImg;
  final String secondImg;
  final String cutOffTime;
  final String firstButtonName;
  final String secondButtonName;

  @override
  Widget build(BuildContext context) {
    return MatchDisplay(
      matchNum: matchNum,
      firstTeam: firstTeam,
      secondTeam: secondTeam,
      firstImg: firstImg,
      secondImg: secondImg,
      cutOffTime: cutOffTime,
      firstButtonName: firstButtonName,
      secondButtonName: secondButtonName,
    );
  }
}
