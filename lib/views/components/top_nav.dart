import 'package:flutter/material.dart';

import 'package:lloud_mobile/views/components/points_balance.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/nav_logo.dart';
import 'package:lloud_mobile/views/components/notifications_icon.dart';

class TopNav extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  TopNav({
    Key key,
  })  : preferredSize = Size.fromHeight(56.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: LloudTheme.black,
      title: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            child: NavLogo(),
          ),
          Container(
            alignment: Alignment.centerLeft,
            child: PointsBalance(),
          ),
          Container(
            alignment: Alignment.centerRight,
            child: NotificationsIcon(),
          ),
        ],
      ),
    );
  }
}
