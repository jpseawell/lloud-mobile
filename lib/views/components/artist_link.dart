import 'package:flutter/material.dart';
import 'package:lloud_mobile/routes.dart';

class ArtistLink extends StatelessWidget {
  final int _artistId;
  final String _artistName;
  final Color txtColor;
  final double txtSize;
  final Function preLinkCB;

  ArtistLink(this._artistId, this._artistName,
      {this.txtColor, this.txtSize = 20, this.preLinkCB});

  @override
  Widget build(BuildContext context) {
    return ButtonTheme(
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      height: 16,
      child: FlatButton(
          onPressed: () {
            if (preLinkCB != null) {
              preLinkCB(context);
            }

            Navigator.of(context)
                .pushNamed(Routes.artist, arguments: this._artistId);
          },
          child: Container(
              alignment: Alignment.centerLeft,
              margin: EdgeInsets.only(right: 12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text(
                  this._artistName,
                  style: TextStyle(
                      fontSize: txtSize,
                      color: txtColor,
                      fontWeight: FontWeight.w300),
                ),
              ))),
    );
  }
}
