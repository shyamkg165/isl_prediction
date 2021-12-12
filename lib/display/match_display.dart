import '/screens/match_predict_screen.dart';
import '/screens/show_predictions_screen.dart';
import '/screens/show_points_screen.dart';
import 'package:flutter/material.dart';
import '/components/rounded_button.dart';

int matchNum;
String playerId;
String matchVariant_1;
String matchVariant_2;
String matchVariant_3;
String matchVariant_4;

class MatchDisplay extends StatelessWidget {
  MatchDisplay(
      {@required this.matchNum,
      @required this.firstTeam,
      @required this.secondTeam,
      @required this.firstImg,
      @required this.secondImg,
      @required this.cutOffTime,
      this.matchStatus,
      @required this.firstButtonName,
      this.secondButtonName});

  final int matchNum;
  final String firstTeam;
  final String secondTeam;
  final String firstImg;
  final String secondImg;
  final String cutOffTime;
  final String matchStatus;
  final String firstButtonName;
  final String secondButtonName;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(
            'MATCH #$matchNum',
            style: TextStyle(
              color: Colors.white,
              fontSize: 50.0,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.start,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              CircleAvatar(
                radius: 100.0,
                backgroundImage: AssetImage(firstImg),
              ),
              Text(
                'V/S',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 25.0,
                  fontWeight: FontWeight.w600,
                ),
              ),
              CircleAvatar(
                radius: 100.0,
                backgroundImage: AssetImage(secondImg),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(firstTeam + ' v/s ',
                  style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
              Text(secondTeam,
                  style: TextStyle(
                      fontFamily: 'SourceSansPro',
                      fontSize: 40.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold)),
            ],
          ),
          Row(
            children: <Widget>[
              PredictButton(
                  title: firstButtonName,
                  colour: Colors.blue[900],
                  onPressed: () {
                    if (firstButtonName == 'PREDICT NOW') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MatchPredictScreen(
                                  matchNum: matchNum,
                                  firstTeam: firstTeam,
                                  secondTeam: secondTeam,
                                  firstImg: firstImg,
                                  secondImg: secondImg)));
                    }
                    if (firstButtonName == 'SHOW PREDICTIONS') {
                      //sleep(Duration(milliseconds: 1000));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowPredictionsScreen(
                                  matchNum: matchNum,
                                  firstTeam: firstTeam,
                                  secondTeam: secondTeam,
                                  firstImg: firstImg,
                                  secondImg: secondImg)));
                    }
                    if (firstButtonName == 'SHOW RESULTS') {
                      //getPlayerMatchPoints(matchNum);
                      //sleep(Duration(milliseconds: 1000));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ShowPointsScreen(matchNum: matchNum)));
                    }
                  }),
              PredictButton(
                  title: secondButtonName,
                  colour: Colors.blue[900],
                  onPressed: () {
                    if (secondButtonName == 'PREDICT NOW') {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MatchPredictScreen(
                                  matchNum: matchNum,
                                  firstTeam: firstTeam,
                                  secondTeam: secondTeam,
                                  firstImg: firstImg,
                                  secondImg: secondImg)));
                    }
                    if (secondButtonName == 'SHOW PREDICTIONS') {
                      //sleep(Duration(milliseconds: 1000));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ShowPredictionsScreen(
                                  matchNum: matchNum,
                                  firstTeam: firstTeam,
                                  secondTeam: secondTeam,
                                  firstImg: firstImg,
                                  secondImg: secondImg)));
                    }
                    if (secondButtonName == 'SHOW RESULTS') {
                      //getPlayerMatchPoints(matchNum);
                      //sleep(Duration(milliseconds: 1000));
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ShowPointsScreen(matchNum: matchNum)));
                    }
                  }),

            ],
          ),

          Text('Cut off time ends in : $cutOffTime',
              style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
