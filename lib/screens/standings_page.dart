import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '/display/scrollable_widget.dart';
import '/constants.dart';

final _firestore = FirebaseFirestore.instance;

class TotalPoints {
  String playerID;
  int totalPoints_1;
  int totalPoints_2;
  int totalPoints_3;
  int totalPoints_4;
  int sumOfAllPoints;
  TotalPoints(
      {this.playerID,
      this.totalPoints_1,
      this.totalPoints_2,
      this.totalPoints_3,
      this.totalPoints_4,
      this.sumOfAllPoints});
}

List<TotalPoints> totalPointsList = [];

class StandingsPage extends StatefulWidget {
  @override
  _StandingsPageState createState() => _StandingsPageState();
}

class _StandingsPageState extends State<StandingsPage> {
  int sortColumnIndex;
  bool isAscending = false;

  @override
  void initState() {
    calculateStandings();

    super.initState();
  }

  void calculateStandings() async {
    String playerID;
    int totalPoints_1;
    int totalPoints_2;
    int totalPoints_3;
    int totalPoints_4;

    totalPointsList.clear();
    final playerNames = await _firestore.collection('matchpoints').get();
    for (var player in playerNames.docs) {
      playerID = player.id;

      totalPoints_1 = 0;
      totalPoints_2 = 0;
      totalPoints_3 = 0;
      totalPoints_4 = 0;

      final matches = await _firestore
          .collection('matchpoints')
          .doc(player.id)
          .collection('Matches')
          .get();

      for (var match in matches.docs) {
        totalPoints_1 += match.data()[kHeadingVariant_1];
        totalPoints_2 += match.data()[kHeadingVariant_2];
        totalPoints_3 += match.data()[kHeadingVariant_3];
        totalPoints_4 += match.data()[kHeadingVariant_4];
      }
      print(totalPoints_1);
      print(totalPoints_2);
      print(totalPoints_3);
      print(totalPoints_4);

      final totalPoints = TotalPoints(
          playerID: playerID,
          totalPoints_1: totalPoints_1,
          totalPoints_2: totalPoints_2,
          totalPoints_3: totalPoints_3,
          totalPoints_4: totalPoints_4,
          sumOfAllPoints: (totalPoints_1 +
              totalPoints_2 +
              totalPoints_3 +
              totalPoints_4));

      totalPointsList.add(totalPoints);
    }

    setState(() {
      sortStandings();
    });
  }

  void sortStandings() {
    totalPointsList
        .sort((a, b) => b.sumOfAllPoints.compareTo(a.sumOfAllPoints));
    int rank = 0;
    for (var playerTotalPoints in totalPointsList) {
      rank++;

      _firestore.collection('standings').doc(playerTotalPoints.playerID).set(
          {'sumOfAllPoints': playerTotalPoints.sumOfAllPoints, 'rank': rank},
          SetOptions(merge: true)).then((_) {
        print("Standings Success!");
      });
    }
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
      rows: getRows(totalPointsList),
    );
  }

  List<DataColumn> getColumns(List<String> columns) => columns
      .map((String column) => DataColumn(
            label: Text(column),
            onSort: onSort,
          ))
      .toList();

  List<DataRow> getRows(List<TotalPoints> totalPointsList) =>
      totalPointsList.map((TotalPoints playerTotalPoints) {
        final cells = [
          playerTotalPoints.playerID,
          playerTotalPoints.totalPoints_1,
          playerTotalPoints.totalPoints_2,
          playerTotalPoints.totalPoints_3,
          playerTotalPoints.totalPoints_4,
          playerTotalPoints.sumOfAllPoints
        ];

        return DataRow(cells: getCells(cells));
      }).toList();

  List<DataCell> getCells(List<dynamic> cells) =>
      cells.map((data) => DataCell(Text('$data'))).toList();

  void onSort(int columnIndex, bool ascending) {
    if (columnIndex == 0) {
      totalPointsList.sort((user1, user2) =>
          compareInt(ascending, user1.sumOfAllPoints, user2.sumOfAllPoints));
    } else if (columnIndex == 1) {
      totalPointsList.sort((user1, user2) => compareInt(
          ascending, user1.totalPoints_1, user2.totalPoints_1));
    } else if (columnIndex == 2) {
      totalPointsList.sort((user1, user2) =>
          compareInt(ascending, user1.totalPoints_2, user2.totalPoints_2));
    } else if (columnIndex == 3) {
      totalPointsList.sort((user1, user2) => compareInt(
          ascending, user1.totalPoints_3, user2.totalPoints_3));
    } else if (columnIndex == 4) {
      totalPointsList.sort((user1, user2) => compareInt(
          ascending, user1.totalPoints_4, user2.totalPoints_4));
    } else if (columnIndex == 5) {
      totalPointsList.sort((user1, user2) =>
          compareInt(ascending, user1.sumOfAllPoints, user2.sumOfAllPoints));
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
    return Container(
      //child: ListView(children: widget.predictions),
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
                      Text(kHeadingVariant_3, style: TextStyle(fontSize: 20.0))
                    ],
                  ),
                  Column(
                    children: [
                      Text(kHeadingVariant_4, style: TextStyle(fontSize: 20.0))
                    ],
                  ),
                  Column(
                    children: [
                      Text('Total Points', style: TextStyle(fontSize: 20.0))
                    ],
                  ),
                ]),
                for (var playerTotalPoints in totalPointsList)
                  TableRow(
                    children: [
                      Column(
                        children: [
                          Text(playerTotalPoints.playerID,
                              style: TextStyle(fontSize: 20.0))
                        ],
                      ),
                      Column(
                        children: [
                          Text(playerTotalPoints.totalPoints_1.toString(),
                              style: TextStyle(fontSize: 20.0))
                        ],
                      ),
                      Column(
                        children: [
                          Text(playerTotalPoints.totalPoints_2.toString(),
                              style: TextStyle(fontSize: 20.0))
                        ],
                      ),
                      Column(
                        children: [
                          Text(playerTotalPoints.totalPoints_3.toString(),
                              style: TextStyle(fontSize: 20.0))
                        ],
                      ),
                      Column(
                        children: [
                          Text(playerTotalPoints.totalPoints_4.toString(),
                              style: TextStyle(fontSize: 20.0))
                        ],
                      ),
                      Column(
                        children: [
                          Text(playerTotalPoints.sumOfAllPoints.toString(),
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
    );
  }*/
}
