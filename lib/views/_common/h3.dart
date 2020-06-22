import 'package:flutter/material.dart';

class H3 extends StatelessWidget {
  final String _text;

  H3(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      this._text,
      style: TextStyle(
          fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'Raleway'),
    );
  }
}
