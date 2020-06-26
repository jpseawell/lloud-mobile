import 'package:flutter/cupertino.dart';
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

  void _showSongMenuDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(children: <Widget>[
                  Expanded(
                      child: FlatButton(
                    child: Text("Report as Offensive"),
                    textColor: LloudTheme.red,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  )),
                ]),
                Divider(
                  height: 1,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                        child: FlatButton(
                      child: Text("Cancel"),
                      textColor: LloudTheme.black,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ))
                  ],
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1 / 1,
        child: Container(
          decoration: new BoxDecoration(
              color: LloudTheme.black,
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
                      flex: 3,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            PlayButton(this._song.id, this._song.audioUrl)
                          ])),
                  Column(children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SongTitle(this._song.title),
                              ],
                            )),
                        Container(
                            constraints: BoxConstraints(maxWidth: 130),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                LikeButton(this._song.id, this._song.likesCount,
                                    this._song.isLiked),
                              ],
                            ))
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                ArtistLink(
                                  this._song.artistId,
                                  this._song.artistName,
                                  txtColor: LloudTheme.white,
                                )
                              ],
                            )),
                        SizedBox(
                          width: 40,
                          child: FlatButton(
                              padding: EdgeInsets.zero,
                              onPressed: () {
                                _showSongMenuDialog(context);
                              },
                              child: Text(
                                "...",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: Color.fromRGBO(255, 255, 255, 1.0),
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              )),
                        )
                      ],
                    )
                  ]),
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
    return Container(
      margin: EdgeInsets.only(right: 12),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Text(
          this._text,
          style: TextStyle(
              color: Color.fromRGBO(255, 255, 255, 1.0),
              fontSize: 32,
              fontFamily: 'Raleway',
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
