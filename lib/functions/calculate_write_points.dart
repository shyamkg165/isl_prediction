import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/constants.dart';

final _firestore = FirebaseFirestore.instance;

class PlayerMatchPoints {
  String playerID;
  int playerPoints_1;
  int playerPoints_2;
  int playerPoints_3;
  int playerPoints_4;
  int playerTotalPoints;
  PlayerMatchPoints(
      {this.playerID,
      this.playerPoints_1,
      this.playerPoints_2,
      this.playerPoints_3,
      this.playerPoints_4,
      this.playerTotalPoints});
}

class MatchPrediction {
  int matchNum;
  String playerId;
  String matchVariant_1;
  String matchVariant_2;
  String matchVariant_3;
  String matchVariant_4;
  MatchPrediction(
      {this.matchNum,
      this.playerId,
      this.matchVariant_1,
      this.matchVariant_2,
      this.matchVariant_3,
      this.matchVariant_4});
}

class NumCorrectPrediction {
  int numOfCorrectPrediction_1;
  int numOfCorrectPrediction_2;
  int numOfCorrectPrediction_3;
  int numOfCorrectPrediction_4;
}

List<PlayerMatchPoints> playerMatchPointsList = [];
List<MatchPrediction> matchPredictionList = [];
bool resultRead = false;

List<PlayerMatchPoints> calculatePoints(int matchNum, String matchVariant_1,
    String matchVariant_2, String matchVariant_3, String matchVariant_4) {
  readPredictions(
      matchNum, matchVariant_1, matchVariant_2, matchVariant_3, matchVariant_4);
  sleep(Duration(milliseconds: 1000));

  return playerMatchPointsList;
}

void readPredictions(
    int actualMatchNumber,
    String actualMatchVariant_1,
    String actualMatchVariant_2,
    String actualMatchVariant_3,
    String actualMatchVariant_4) async {
  int numOfCorrectPrediction_1 = 0;
  int numOfCorrectPrediction_2 = 0;
  int numOfCorrectPrediction_3 = 0;
  int numOfCorrectPrediction_4 = 0;

  int matchNum;
  String playerId;
  String matchVariant_1;
  String matchVariant_2;
  String matchVariant_3;
  String matchVariant_4;

  int playerPoints_1;
  int playerPoints_2;
  int playerPoints_3;
  int playerPoints_4;

  final readPrediction = await _firestore
      .collection('matchprediction')
      .where("matchnum", isEqualTo: actualMatchNumber)
      .get();

  int count = 0;
  while (readPrediction.docs.isEmpty) {
    sleep(Duration(milliseconds: 1000));
    count++;
    if (count > 30) {
      break;
    }
  }

  matchPredictionList.clear();

  for (var match in readPrediction.docs) {
    matchNum = match.data()['matchnum'];
    playerId = match.data()['playerid'];
    matchVariant_1 = match.data()[kMatchVariant_1];
    matchVariant_2 = match.data()[kMatchVariant_2];
    matchVariant_3 = match.data()[kMatchVariant_3];
    matchVariant_4 = match.data()[kMatchVariant_4];

    if (matchVariant_1 == actualMatchVariant_1) {
      numOfCorrectPrediction_1++;
    }
    if (matchVariant_2 == actualMatchVariant_2) {
      numOfCorrectPrediction_2++;
    }
    if (matchVariant_3 == actualMatchVariant_3) {
      numOfCorrectPrediction_3++;
    }
    if (matchVariant_4 == actualMatchVariant_4) {
      numOfCorrectPrediction_4++;
    }

    final matchPrediction = MatchPrediction(
      playerId: playerId,
      matchNum: matchNum,
      matchVariant_1: matchVariant_1,
      matchVariant_2: matchVariant_2,
      matchVariant_3: matchVariant_3,
      matchVariant_4: matchVariant_4,
    );
    matchPredictionList.add(matchPrediction);
  }
  resultRead = false;

  playerMatchPointsList.clear();

  for (var num = 0; num < matchPredictionList.length; num++) {
    playerId = matchPredictionList[num].playerId;

    if (matchPredictionList[num].matchVariant_1 == actualMatchVariant_1) {
      playerPoints_1 = (kVariantPoints_1 ~/ numOfCorrectPrediction_1).toInt();
    } else {
      playerPoints_1 = 0;
    }
    if (matchPredictionList[num].matchVariant_2 == actualMatchVariant_2) {
      playerPoints_2 = (kVariantPoints_2 ~/ numOfCorrectPrediction_2).toInt();
    } else {
      playerPoints_2 = 0;
    }
    if (matchPredictionList[num].matchVariant_3 == actualMatchVariant_3) {
      playerPoints_3 = (kVariantPoints_3 ~/ numOfCorrectPrediction_3).toInt();
    } else {
      playerPoints_3 = 0;
    }
    if (matchPredictionList[num].matchVariant_4 == actualMatchVariant_4) {
      playerPoints_4 = (kVariantPoints_4 ~/ numOfCorrectPrediction_4).toInt();
    } else {
      playerPoints_4 = 0;
    }
    final playerMatchPoints = PlayerMatchPoints(
        playerID: playerId,
        playerPoints_1: playerPoints_1,
        playerPoints_2: playerPoints_2,
        playerPoints_3: playerPoints_3,
        playerPoints_4: playerPoints_4);
    playerMatchPointsList.add(playerMatchPoints);
  }

  writePlayerPoints(playerMatchPointsList, matchNum);
  //writeStandings(playerMatchPointsList);
}

void writePlayerPoints(
    List<PlayerMatchPoints> playerMatchPointsList, int matchNum) {
  for (var num = 0; num < playerMatchPointsList.length; num++) {
    _firestore
        .collection('matchpoints')
        .doc(playerMatchPointsList[num].playerID)
        .set({'playerId': playerMatchPointsList[num].playerID},
            SetOptions(merge: true));

    _firestore
        .collection('matchpoints')
        .doc(playerMatchPointsList[num].playerID)
        .collection('Matches')
        .doc(matchNum.toString())
        .set({
      'matchnum': matchNum,
      'points1': playerMatchPointsList[num].playerPoints_1,
      'points2': playerMatchPointsList[num].playerPoints_2,
      'points3': playerMatchPointsList[num].playerPoints_3,
      'points4': playerMatchPointsList[num].playerPoints_4
    }, SetOptions(merge: true)).then((_) {
      print("Success!");
    });
  }
}
