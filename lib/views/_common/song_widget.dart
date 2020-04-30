import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

import '../../models/song.dart';
import '../_common/like_button.dart';
import '../_common/play_button.dart';
import '../_common/artist_link.dart';

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
          child: Stack(children: <Widget>[
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[
                    Colors.black.withAlpha(0),
                    Colors.black12,
                    Colors.black
                  ],
                ),
              ),
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 4,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            PlayButton(this._song.id, this._song.audioUrl)
                          ])),
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SongTitle(this._song.title),
                                ArtistLink(
                                  this._song.artistId,
                                  this._song.artistName,
                                  txtColor: LloudTheme.white,
                                )
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
            ),
          ]),
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
