import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/store_item.dart';

class CostBadge extends StatelessWidget {
  final StoreItem storeItem;

  CostBadge(this.storeItem);

  List<Widget> children() {
    if (storeItem.comingSoon)
      return [
        Text('Coming Soon',
            style: TextStyle(
                color: LloudTheme.white,
                fontSize: 20,
                fontWeight: FontWeight.bold))
      ];

    if (storeItem.qty <= 0)
      return [
        Text('Sold Out',
            style: TextStyle(
                color: LloudTheme.white,
                fontSize: 20,
                fontWeight: FontWeight.bold))
      ];

    return [
      Text('${storeItem.cost}',
          style: TextStyle(
              color: LloudTheme.white,
              fontSize: 20,
              fontWeight: FontWeight.bold)),
      SizedBox(width: 4),
      Text(
        'points',
        style:
            TextStyle(color: LloudTheme.white2.withOpacity(.75), fontSize: 16),
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
            color: LloudTheme.red, borderRadius: BorderRadius.circular(4.0)),
        child: Row(mainAxisSize: MainAxisSize.min, children: children()));

    // return Column(
    //   crossAxisAlignment: CrossAxisAlignment.center,
    //   children: <Widget>[
    //     Text(
    //       'Sold\nOut',
    //       textAlign: TextAlign.center,
    //       style: TextStyle(
    //           fontWeight: FontWeight.w900,
    //           color: LloudTheme.white,
    //           fontSize: 20),
    //     ),
    //   ],
    // );
  }
}
