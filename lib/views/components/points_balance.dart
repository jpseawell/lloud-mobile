import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/auth.dart';

class PointsBalance extends StatefulWidget {
  @override
  _PointsBalanceState createState() => _PointsBalanceState();
}

class _PointsBalanceState extends State<PointsBalance> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
        builder: (context, auth, _) => Container(
              alignment: Alignment.centerLeft,
              height: 40,
              width: 40,
              child: Text('${auth.account.pointsBalance}'),
            ));
  }
}
