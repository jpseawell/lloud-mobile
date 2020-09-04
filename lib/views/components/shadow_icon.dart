import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';

class ShadowIcon extends StatelessWidget {
  final IconData icon;
  final double size;

  ShadowIcon({@required this.icon, this.size = 28.0});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          left: 0.0,
          top: 2.5,
          child: Icon(
            icon,
            color: Color.fromRGBO(28, 28, 28, .15),
            size: size,
          ),
        ),
        Icon(
          icon,
          color: LloudTheme.white,
          size: size,
        ),
      ],
    );
  }
}
