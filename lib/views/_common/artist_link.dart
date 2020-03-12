import 'package:flutter/material.dart';

class ArtistLink extends StatelessWidget {
  final int _artistId;
  final String _artistName;
  final Color txtColor;

  ArtistLink(this._artistId, this._artistName, {this.txtColor});

  void _goToArtistPage(BuildContext ctx) {
    debugPrint('going to artist page...');
    // Navigator.push(
    //     ctx, MaterialPageRoute(builder: (ctx) => ArtistPage(this._artistId)));
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        padding: EdgeInsets.all(0),
        onPressed: () {
          _goToArtistPage(context);
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            this._artistName,
            style: TextStyle(
                fontSize: 20, color: txtColor, fontWeight: FontWeight.w300),
          ),
        ));
  }
}
