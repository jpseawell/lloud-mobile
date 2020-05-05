import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/providers/points.dart';

class TotalPoints extends StatefulWidget {
  @override
  _TotalPointsState createState() => _TotalPointsState();
}

class _TotalPointsState extends State<TotalPoints> {
  @override
  Widget build(BuildContext context) {
    final points = Provider.of<Points>(context).points;
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Container(
        padding: EdgeInsets.symmetric(vertical: 0, horizontal: 8.0),
        child: Icon(Icons.score),
      ),
      Text(points.toString())
    ]);
  }
}
