import 'package:flutter/material.dart';

/// This class contains styles for the app

class LloudTheme {
  static final Color _red = Color.fromRGBO(255, 64, 64, 1.0);
  static final Color _black = Color.fromRGBO(28, 28, 28, 1.0);
  static final Color _white = Color.fromRGBO(255, 255, 255, 1.0);

  static get black => _black;
  static get red => _red;
  static get white => _white;

  static ThemeData getThemeData(BuildContext ctx) {
    return ThemeData(primaryColor: _red, textTheme: getTextTheme(ctx));
  }

  static TextTheme getTextTheme(BuildContext ctx) {
    return Theme.of(ctx)
        .textTheme
        .apply(displayColor: _red, fontFamily: 'Lato');
    // body1: TextStyle(color: _black, fontFamily: 'Lato'),
    // title: TextStyle(
    //     fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
    // button: TextStyle(color: _red, fontFamily: 'Lato'));
  }
}
