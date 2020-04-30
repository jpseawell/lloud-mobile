import 'dart:convert';
import 'package:flutter/material.dart';

import '../../util/dal.dart';

class TotalPoints extends StatefulWidget {
  @override
  _TotalPointsState createState() => _TotalPointsState();
}

class _TotalPointsState extends State<TotalPoints> {
  Future<Text> _futureTxtPoints;

  Future<Text> fetchTxtPoints() async {
    final response = await DAL.instance().fetch('users/points');
    Map<String, dynamic> jsonObj = json.decode(response.body);
    return Text(jsonObj['data']['points'].toString());
  }

  @override
  void initState() {
    super.initState();
    _futureTxtPoints = fetchTxtPoints();
  }

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        child: Icon(Icons.score),
      ),
      FutureBuilder<Text>(
        future: fetchTxtPoints(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return snapshot.data;
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }

          return CircularProgressIndicator();
        },
      )
    ]);
  }
}
