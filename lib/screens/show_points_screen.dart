import 'package:flutter/material.dart';
import '/functions/calculate_write_points.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/constants.dart';
import '/display/scrollable_widget.dart';

final _firestore = FirebaseFirestore.instance;
int matchNum;
String playerId;
String matchVariant_1;
String matchVariant_2;
String matchVariant_3;
String matchVariant_4;
List<PlayerMatchPoints> playerMatchPointsList = [];

class ShowPointsScreen extends StatefulWidget {
  ShowPointsScreen({@required this.matchNum});

  static const String id = 'show_points_screen';
  final int matchNum;

  @override
  _ShowPointsScreenState createState() => _ShowPointsScreenState();
}

class _ShowPointsScreenState extends State<ShowPointsScreen> {
  int sortColumnIndex;
  bool isAscending = false;
  @override
  void initState() {
    // TODO: implement initState

    getPlayerMatchPoints(widget.matchNum);
    super.initState();
  }

  void getPlayerMatchPoints(int matchNumber) async {
    int playerPoints_1 = 0;
    int playerPoints_2 = 0;
    int playerPoints_3 = 0;
    int playerPoints_4 = 0;
    int playerTotalPoints = 0;

    print('in getPlayerMatchPoints');

    final playerNames = await _firestore.collection('matchpoints').get();

    playerMatchPointsList.clear();
    for (var player in playerNames.docs) {
      playerId = player.id;

      final currentMatch = await _firestore
          .collection('matchpoints')
          .doc(player.id)
          .collection('Matches')
          .where("matchnum", isEqualTo: matchNumber)
          .get();

      if (!currentMatch.docs.isEmpty) {
        for (var match in currentMatch.docs) {
          matchNum = match.data()['matchnum'];
          playerPoints_1 = match.data()['points1'];
          playerPoints_2 = match.data()['points2'];
          playerPoints_3 = match.data()['points3'];
          playerPoints_4 = match.data()['points4'];
          playerTotalPoints = playerPoints_1 +
              playerPoints_2 +
              playerPoints_3 +
              playerPoints_4;
        }
      } else {
        matchNum = matchNumber;
      }

      print(playerId);
      print(matchNum);
      print(playerPoints_1);
      print(playerPoints_2);
      print(playerPoints_3);
      print(playerPoints_4);

      final playerMatchPoints = PlayerMatchPoints(
          playerID: playerId,
          playerPoints_1: playerPoints_1,
          playerPoints_2: playerPoints_2,
          playerPoints_3: playerPoints_3,
          playerPoints_4: playerPoints_4,
          playerTotalPoints: playerTotalPoints);

      playerMatchPointsList.add(playerMatchPoints);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(klogoPath),
            fit: BoxFit.contain,
          ),
        ),
        child: ScrollableWidget(child: buildDataTable()),
      ),
    );
  }

  Widget buildDataTable() {
    final columns = [
      'Player',
      'Match Num',
      kHeadingVariant_1,
      kHeadingVariant_2,
      kHeadingVariant_3,
      kHeadingVariant_4,
      'Total Points'
    ];

    return DataTable(
      sortAscending: isAscending,
      sortColumnIndex: sortColumnIndex,
      columns: getColumns(columns),
      rows: getRows(playerMatchPointsList),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<PlayerMatchPoints> matchPointsList) =>
      playerMatchPointsList.map((PlayerMatchPoints playerMatchPoints) {
        final cells = [
          playerMatchPoints.playerID,
          matchNum,
          playerMatchPoints.playerPoints_1,
          playerMatchPoints.playerPoints_2,
          playerMatchPoints.playerPoints_3,
          playerMatchPoints.playerPoints_4,
          playerMatchPoints.playerTotalPoints
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      playerMatchPointsList.sort((user1, user2) => compareInt(
          ascending, user1.playerTotalPoints, user2.playerTotalPoints));
    } else if (columnIndex == 1) {
      playerMatchPointsList.sort((user1, user2) => compareInt(
          ascending, user1.playerPoints_1, user2.playerPoints_1));
    } else if (columnIndex == 2) {
      playerMatchPointsList.sort((user1, user2) =>
          compareInt(ascending, user1.playerPoints_2, user2.playerPoints_2));
    } else if (columnIndex == 3) {
      playerMatchPointsList.sort((user1, user2) => compareInt(
          ascending, user1.playerPoints_3, user2.playerPoints_3));
    } else if (columnIndex == 4) {
      playerMatchPointsList.sort((user1, user2) => compareInt(
          ascending, user1.playerPoints_4, user2.playerPoints_4));
    } else if (columnIndex == 5) {
      playerMatchPointsList.sort((user1, user2) => compareInt(
          ascending, user1.playerTotalPoints, user2.playerTotalPoints));
    }
    setState(() {
      this.sortColumnIndex = columnIndex;
      this.isAscending = ascending;
    });
  }

  int compareInt(bool ascending, int value1, int value2) =>
      ascending ? value1.compareTo(value2) : value2.compareTo(value1);

/*@override
  Widget build(BuildContext context) {
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
            image: AssetImage(logoPath),
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
                        Text(kHeadingVariant_1, style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                    Column(
                      children: [
                        Text(kHeadingVariant_2, style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                    Column(
                      children: [
                        Text(kHeadingVariant_3,
                            style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                    Column(
                      children: [
                        Text(kHeadingVariant_4,
                            style: TextStyle(fontSize: 20.0))
                      ],
                    ),
                  ]),
                  for (var playerMatchPoints in playerMatchPointsList)
                    TableRow(
                      children: [
                        Column(
                          children: [
                            Text(playerMatchPoints.playerID,
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(widget.matchNum.toString(),
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                                playerMatchPoints.playerPoints_1.toString(),
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(playerMatchPoints.playerPoints_2.toString(),
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                                playerMatchPoints.playerPoints_3
                                    .toString(),
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                                playerMatchPoints.playerPoints_4
                                    .toString(),
                                style: TextStyle(fontSize: 20.0))
                          ],
                        ),
                      ],
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }*/
}
