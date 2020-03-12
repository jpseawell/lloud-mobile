import 'package:flutter/material.dart';

class H2 extends StatelessWidget {
  final String _text;

  H2(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      this._text,
      style: TextStyle(
          fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
    );
  }
}
