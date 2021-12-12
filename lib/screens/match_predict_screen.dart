import '/components/rounded_button.dart';
import '/screens/predictions_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/display/current_match.dart';
import '/constants.dart';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;
List<String> playerNameList = [];
final textControllerMatchVariant_1 = TextEditingController();
final textControllerMatchVariant_2 = TextEditingController();
final textControllerMatchVariant_3 = TextEditingController();
final textControllerMatchVariant_4 = TextEditingController();

class MatchPredictScreen extends StatefulWidget {
  MatchPredictScreen(
      {@required this.matchNum,
      @required this.firstTeam,
      @required this.secondTeam,
      @required this.firstImg,
      @required this.secondImg});

  static const String id = 'match_predict_screen';

  final int matchNum;
  final String firstTeam;
  final String secondTeam;
  final String firstImg;
  final String secondImg;

  @override
  _MatchPredictScreenState createState() => _MatchPredictScreenState();
}

class _MatchPredictScreenState extends State<MatchPredictScreen> {
  final _auth = FirebaseAuth.instance;
  String matchVariant_1;
  String matchVariant_2;
  String matchVariant_3;
  String matchVariant_4;

  @override
  void initState() {
    // TODO: implement initState
    playerNameList.clear();
    readPlayerNames(widget.firstTeam);
    readPlayerNames(widget.secondTeam);

    super.initState();
    getCurrentUser();
  }

  void readPlayerNames(String teamName) async {
    final readPlayers =
        await _firestore.collection(kfirestoreSquadPath + teamName).get();
    for (var players in readPlayers.docs) {
      print('adding Player' + players.data()['Player'].toString());
      playerNameList.add(players.data()['Player']);
    }

    final currPrediction = _firestore
        .collection('matchprediction')
        .doc(loggedInUser.uid + widget.matchNum.toString());
    await currPrediction.get().then<dynamic>((DocumentSnapshot snapshot) async {
      setState(() {
        if (snapshot.data() != null) {
          matchVariant_1 = snapshot.get(kMatchVariant_1);
          matchVariant_2 = snapshot.get(kMatchVariant_2);
          matchVariant_3 = snapshot.get(kMatchVariant_3);
          matchVariant_4 = snapshot.get(kMatchVariant_4);
        }
      });
    });
    setState(() {});
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
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
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(klogoPath),
              fit: BoxFit.contain,
            ),
          ),
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
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.black,
                              focusColor: Colors.redAccent,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                              value: matchVariant_1,
                              items: [
                                widget.firstTeam,
                                widget.secondTeam
                              ].map<DropdownMenuItem<String>>((String value) {
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
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.black,
                              focusColor: Colors.redAccent,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                              value: matchVariant_2,
                              items: playerNameList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
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
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.black,
                              focusColor: Colors.redAccent,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                              value: matchVariant_3,
                              items: playerNameList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
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
                                    fontSize: 25.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                          Expanded(
                            child: DropdownButton<String>(
                              dropdownColor: Colors.black,
                              focusColor: Colors.redAccent,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600),
                              value: matchVariant_4,
                              items: playerNameList
                                  .map<DropdownMenuItem<String>>(
                                      (String value) {
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
                    title: 'SUBMIT',
                    colour: Colors.blue[900],
                    onPressed: () {
                      textControllerMatchVariant_1.clear();
                      textControllerMatchVariant_2.clear();
                      textControllerMatchVariant_3.clear();
                      textControllerMatchVariant_4.clear();
                      print(matchVariant_1);
                      _firestore
                          .collection('matchprediction')
                          .doc(loggedInUser.uid + widget.matchNum.toString())
                          .set({
                        'matchnum': widget.matchNum,
                        kMatchVariant_1: matchVariant_1,
                        kMatchVariant_2: matchVariant_2,
                        kMatchVariant_3: matchVariant_3,
                        kMatchVariant_4: matchVariant_4,
                        'playerid': loggedInUser.email
                      }, SetOptions(merge: true)).then((_) {
                        print("Success!");
                      });
                      print('data written to firestore');
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PredictionsPage()));
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
