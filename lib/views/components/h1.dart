import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class H1 extends StatelessWidget {
  final String _text;
  final Color color;

  H1(this._text, {this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      this._text,
      style: TextStyle(
          fontSize: 32,
          fontWeight: FontWeight.bold,
          fontFamily: 'Raleway',
          color: this.color ?? LloudTheme.black),
    );
  }
}
