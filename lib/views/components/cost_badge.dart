import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';

class CostBadge extends StatefulWidget {
  final int _cost;
  final int _qty;

  CostBadge(this._cost, this._qty);

  @override
  _CostBadgeState createState() => _CostBadgeState(this._cost, this._qty);
}

class _CostBadgeState extends State<CostBadge> {
  final int cost;
  final int qty;

  _CostBadgeState(this.cost, this.qty);

  @override
  Widget build(BuildContext context) {
    if (this.qty > 0) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text(
            'cost',
            style: TextStyle(color: LloudTheme.white),
          ),
          Text(
            this.cost.toString(),
            style: TextStyle(
                fontWeight: FontWeight.w900,
                color: LloudTheme.white,
                fontSize: 24),
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(
          'Sold\nOut',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontWeight: FontWeight.w900,
              color: LloudTheme.white,
              fontSize: 20),
        ),
      ],
    );
  }
}
