import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/models/account.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/account.dart';
import 'package:lloud_mobile/views/components/nav_logo.dart';
import 'package:lloud_mobile/views/components/notifications.dart';

class TopNav extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  TopNav({
    Key key,
  })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    Account acct = Provider.of<AccountProvider>(context).account;
    int points = (acct != null) ? acct.pointsBalance : 0;

    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: LloudTheme.black,
      title: Row(
        children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            height: 40,
            width: 40,
            child: Text(points.toString()),
          ),
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.center,
              child: NavLogo(),
            ),
          ),
          Notifications(userId: acct.userId),
        ],
      ),
    );
  }
}
