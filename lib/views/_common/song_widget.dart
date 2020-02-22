import 'package:flutter/material.dart';

import '../../models/song.dart';

class SongWidget extends StatefulWidget {
  final Song song;

  SongWidget(this.song);

  @override
  _SongWidgetState createState() => _SongWidgetState(this.song);
}

class _SongWidgetState extends State<SongWidget> {
  final Song _song;

  _SongWidgetState(this._song);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.all(24.0),
          color: Color.fromRGBO(122, 120, 111, .9),
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[Text('Play')])),
              Expanded(
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SongTitle(this._song.title),
                            ArtistLink(
                                this._song.artistId, this._song.artistName)
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: Column(
                          children: <Widget>[
                            RaisedButton(
                              onPressed: null,
                              child: Text('Like'),
                            )
                          ],
                        ))
                  ],
                ),
                flex: 1,
              )
            ],
          ),
        ));
  }
}

class SongTitle extends StatelessWidget {
  final String _text;

  SongTitle(this._text);

  @override
  Widget build(BuildContext context) {
    return Text(
      this._text,
      style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
    );
  }
}

class ArtistLink extends StatelessWidget {
  final int _artistId;
  final String _artistName;

  ArtistLink(this._artistId, this._artistName);

  void _goToArtistPage(BuildContext ctx) {
    debugPrint('going to artist page...');
    // Navigator.push(
    //     ctx, MaterialPageRoute(builder: (ctx) => ArtistPage(this._artistId)));
  }

  @override
  Widget build(BuildContext context) {
    return FlatButton(
        onPressed: () {
          _goToArtistPage(context);
        },
        child: Text(this._artistName));
  }
}
