import 'package:flutter/material.dart';

class H1 extends StatelessWidget {
  final String _text;

  H1(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      this._text,
      style: TextStyle(
          fontSize: 32, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
    );
  }
}
