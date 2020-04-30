import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class NavLogo extends StatelessWidget {
  NavLogo();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          'Lloud',
          style: TextStyle(
              fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
        ),
        Text(
          '.',
          style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: 'Raleway',
              color: LloudTheme.red),
        ),
      ],
    );
  }
}
