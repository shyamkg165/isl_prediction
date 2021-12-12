import 'package:flutter/material.dart';
import '/display/predictions_display.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/constants.dart';

final _firestore = FirebaseFirestore.instance;
int matchNum;
String playerId;
String matchVariant_1;
String matchVariant_2;
String matchVariant_3;
String matchVariant_4;
List<PredictionsDisplay> predictionsList = [];

class ShowPredictionsScreen extends StatefulWidget {
  ShowPredictionsScreen(
      {@required this.matchNum,
      @required this.firstTeam,
      @required this.secondTeam,
      @required this.firstImg,
      @required this.secondImg});

  static const String id = 'show_predictions_screen';
  final int matchNum;
  final String firstTeam;
  final String secondTeam;
  final String firstImg;
  final String secondImg;

  @override
  _ShowPredictionsScreenState createState() => _ShowPredictionsScreenState();
}

class _ShowPredictionsScreenState extends State<ShowPredictionsScreen> {
  @override
  void initState() {
    getPredictions(widget.matchNum);
    super.initState();
  }

  void getPredictions(int matchNumber) async {
    final matchPrediction = await _firestore
        .collection('matchprediction')
        .where("matchnum", isEqualTo: matchNumber)
        .get();

    print('in getPredictions');
    print(matchNumber);
    predictionsList.clear();
    for (var match in matchPrediction.docs) {
      matchNum = match.data()['matchnum'];
      playerId = match.data()['playerid'];
      matchVariant_1 = match.data()[kMatchVariant_1];
      matchVariant_2 = match.data()[kMatchVariant_2];
      matchVariant_3 = match.data()[kMatchVariant_3];
      matchVariant_4 = match.data()[kMatchVariant_4];

      print(matchNum);
      print(playerId);
      print(matchVariant_1);
      print(matchVariant_2);
      print(matchVariant_3);
      print(matchVariant_4);

      final predictionDisplay = PredictionsDisplay(
        playerId: playerId,
        matchNum: matchNum.toString(),
        matchVariant_1: matchVariant_1,
        matchVariant_2: matchVariant_2,
        matchVariant_3: matchVariant_3,
        matchVariant_4: matchVariant_4,
      );
      predictionsList.add(predictionDisplay);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    print('size = ' + predictionsList.length.toString());
    return Scaffold(
      appBar: AppBar(
        title: Text(kappBarName),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: Container(
        //child: ListView(children: widget.predictions),
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(klogoPath),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            Container(
              child: Table(
                border: TableBorder.all(
                    color: Colors.black, style: BorderStyle.solid, width: 2),
                children: [
                  TableRow(children: [
                    Column(
                      children: [
                        Text('Player', style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                    Column(
                      children: [
                        Text('MatchNum', style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                    Column(
                      children: [
                        Text(kMatchVariant_1, style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                    Column(
                      children: [Text(kMatchVariant_2, style: TextStyle(fontSize: 20.0))],
                    ),
                    Column(
                      children: [
                        Text(kMatchVariant_3, style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                    Column(
                      children: [
                        Text(kMatchVariant_4, style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                  ]),
                  for (var prediction in predictionsList)
                    TableRow(
                      children: [
                        Column(
                          children: [
                            Text(prediction.playerId,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(prediction.matchNum,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(prediction.matchVariant_1,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(prediction.matchVariant_2,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(prediction.matchVariant_3,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(prediction.matchVariant_4,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                      ],
                    ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
