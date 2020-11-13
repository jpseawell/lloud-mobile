import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';

class EmptyAvatar extends StatelessWidget {
  final double radius;
  final String initial;
  final bool isDark;

  EmptyAvatar({this.radius, this.initial, this.isDark = false});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius,
        backgroundColor: isDark
            ? LloudTheme.black.withOpacity(.10)
            : LloudTheme.white2.withOpacity(.10),
        child: Text(
          initial,
          style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: radius * .8,
              color: isDark ? LloudTheme.black : LloudTheme.white),
        ));
  }
}
