import '/screens/update_result_screen.dart';
import 'package:flutter/material.dart';
import '/components/rounded_button.dart';
import '/display/predictions_display.dart';

List<PredictionsDisplay> predictions = [];

int matchNum;
String playerId;
String matchVariant_1;
String matchVariant_2;
String matchVariant_3;
String matchVariant_4;

class CompletedMatchDisplay extends StatelessWidget {
  CompletedMatchDisplay(
      {@required this.matchNum,
      @required this.firstTeam,
      @required this.secondTeam,
      @required this.firstImg,
      @required this.secondImg,
      @required this.matchStatus});

  final int matchNum;
  final String firstTeam;
  final String secondTeam;
  final String firstImg;
  final String secondImg;
  final String matchStatus;
  final String buttonName = 'UPDATE RESULT';

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
          PredictButton(
              title: buttonName,
              colour: Colors.blue[900],
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => UpdateResultScreen(
                            matchNum: matchNum,
                            firstTeam: firstTeam,
                            secondTeam: secondTeam,
                            firstImg: firstImg,
                            secondImg: secondImg)));
              }),
        ],
      ),
    );
  }
}
