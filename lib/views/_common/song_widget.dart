import 'dart:async';

import 'package:flutter/material.dart';

import '../../models/song.dart';
import '../_common/like_button.dart';
import '../_common/play_button.dart';

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
          decoration: new BoxDecoration(
              image: new DecorationImage(
                  image: new NetworkImage(this._song.imageUrl),
                  fit: BoxFit.cover)),
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 3,
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        PlayButton(this._song.id, this._song.audioUrl)
                      ])),
              Expanded(
                flex: 1,
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
                            LikeButton(this._song.id, this._song.likesCount,
                                this._song.isLiked)
                          ],
                        ))
                  ],
                ),
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
      style: TextStyle(
          color: Color.fromRGBO(255, 255, 255, 1.0),
          fontSize: 32,
          fontFamily: 'Raleway',
          fontWeight: FontWeight.bold),
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
        padding: EdgeInsets.all(0),
        onPressed: () {
          _goToArtistPage(context);
        },
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            this._artistName,
            style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(255, 255, 255, 1.0),
                fontWeight: FontWeight.w300),
          ),
        ));
  }
}
