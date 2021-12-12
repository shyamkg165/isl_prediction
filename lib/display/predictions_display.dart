import 'package:flutter/material.dart';

class PredictionsDisplay extends StatelessWidget {
  PredictionsDisplay(
      {this.matchNum,
      this.playerId,
      this.matchVariant_1,
      this.matchVariant_2,
      this.matchVariant_3,
      this.matchVariant_4});

  final String matchNum;
  final String playerId;
  final String matchVariant_1;
  final String matchVariant_2;
  final String matchVariant_3;
  final String matchVariant_4;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        color: Color(0xFF1D1E33),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Text(playerId,
              style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Text(matchVariant_1,
              style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Text(matchVariant_2,
              style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Text(matchVariant_3,
              style: TextStyle(
                  fontFamily: 'SourceSansPro',
                  fontSize: 40.0,
                  color: Colors.white,
                  fontWeight: FontWeight.bold)),
          Text(matchVariant_4,
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
