import '/components/rounded_button.dart';
import '/screens/completed_match_page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '/display/current_match.dart';
import '/functions/calculate_write_points.dart';
import '/constants.dart';

List<PlayerMatchPoints> playerMatchPointsList = [];
List<String> playerNameList = [];
User loggedInUser;
final _firestore = FirebaseFirestore.instance;

final textControllerMatchVariant_1 = TextEditingController();
final textControllerMatchVariant_2 = TextEditingController();
final textControllerMatchVariant_3 = TextEditingController();
final textControllerMatchVariant_4 = TextEditingController();

class UpdateResultScreen extends StatefulWidget {
  UpdateResultScreen(
      {@required this.matchNum,
      @required this.firstTeam,
      @required this.secondTeam,
      @required this.firstImg,
      @required this.secondImg});

  static const String id = 'update_result_screen';

  final int matchNum;
  final String firstTeam;
  final String secondTeam;
  final String firstImg;
  final String secondImg;

  @override
  _UpdateResultScreenState createState() => _UpdateResultScreenState();
}

class _UpdateResultScreenState extends State<UpdateResultScreen> {
  String matchVariant_1;
  String matchVariant_2;
  String matchVariant_3;
  String matchVariant_4;

  @override
  void initState() {
    playerNameList.clear();
    readPlayerNames(widget.firstTeam, false);
    readPlayerNames(widget.secondTeam, true);
    super.initState();
  }

  void readPlayerNames(String teamName, bool callBuild) async {
    final readPlayers =
        await _firestore.collection(kfirestoreSquadPath + teamName).get();
    for (var players in readPlayers.docs) {
      print('adding Player' + players.data()['Player'].toString());
      playerNameList.add(players.data()['Player']);
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(kappBarName),
        backgroundColor: Colors.blue[900],
      ),
      backgroundColor: Colors.lightBlueAccent,
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              fit: FlexFit.loose,
              child: FittedBox(
                child: CurrentMatch(
                    matchNum: widget.matchNum,
                    firstTeam: widget.firstTeam,
                    secondTeam: widget.secondTeam,
                    firstImg: widget.firstImg,
                    secondImg: widget.secondImg),
              ),
            ),
            Flexible(
              fit: FlexFit.loose,
              child: Column(
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(kMatchVariant_1,
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 40.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black,
                            focusColor: Colors.redAccent,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                            value: matchVariant_1,
                            items: [widget.firstTeam, widget.secondTeam]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                matchVariant_1 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(kMatchVariant_2,
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 40.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black,
                            focusColor: Colors.redAccent,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                            value: matchVariant_2,
                            items: playerNameList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                matchVariant_2 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(kMatchVariant_3,
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 40.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black,
                            focusColor: Colors.redAccent,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                            value: matchVariant_3,
                            items: playerNameList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                matchVariant_3 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      color: Color(0xFF1D1E33),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(kMatchVariant_4,
                              style: TextStyle(
                                  fontFamily: 'SourceSansPro',
                                  fontSize: 40.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                        ),
                        Expanded(
                          child: DropdownButton<String>(
                            dropdownColor: Colors.black,
                            focusColor: Colors.redAccent,
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 30,
                                fontWeight: FontWeight.w600),
                            value: matchVariant_4,
                            items: playerNameList
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (String value) {
                              setState(() {
                                matchVariant_4 = value;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 900.0,
              height: 100.0,
              margin: EdgeInsets.all(15.0),
              decoration: BoxDecoration(
                color: Color(0xFF1D1E33),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: SubmitButton(
                  title: 'UPDATE RESULT',
                  colour: Colors.blue[900],
                  onPressed: () {
                    textControllerMatchVariant_1.clear();
                    textControllerMatchVariant_2.clear();
                    textControllerMatchVariant_3.clear();
                    textControllerMatchVariant_4.clear();
                    _firestore
                        .collection('matchresults')
                        .doc(widget.matchNum.toString())
                        .set({
                      'matchnum': widget.matchNum,
                      kMatchVariant_1: matchVariant_1,
                      kMatchVariant_2: matchVariant_2,
                      kMatchVariant_3: matchVariant_3,
                      kMatchVariant_4: matchVariant_4
                    }, SetOptions(merge: true)).then((_) {
                      print("Success!");
                    });
                    playerMatchPointsList = calculatePoints(widget.matchNum,
                        matchVariant_1, matchVariant_2, matchVariant_3, matchVariant_4);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompletedMatchPage()));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
