import 'package:flutter/material.dart';

class ArtistLink extends StatelessWidget {
  final int _artistId;
  final String _artistName;
  final Color txtColor;

  ArtistLink(this._artistId, this._artistName, {this.txtColor});

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.only(right: 12),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Text(
            this._artistName,
            style: TextStyle(
                fontSize: 20, color: txtColor, fontWeight: FontWeight.w300),
          ),
        ));
  }
}
