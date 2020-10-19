import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';

class EmptyAvatar extends StatelessWidget {
  final double radius;

  EmptyAvatar({this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: radius,
        backgroundColor: LloudTheme.blackLight,
        child: Icon(
          Icons.person,
          color: LloudTheme.white.withOpacity(.25),
          size: radius * 1.5,
        ));
  }
}
