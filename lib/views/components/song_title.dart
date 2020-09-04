import 'package:flutter/material.dart';

class SongTitle extends StatelessWidget {
  final String _text;
  final Color color;
  final double size;

  SongTitle(this._text, {this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          this._text,
          style: TextStyle(
              color: this.color ?? Color.fromRGBO(255, 255, 255, 1.0),
              fontSize: this.size ?? 32,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
