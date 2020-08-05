import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/views/_common/more_btn.dart';
import 'package:lloud_mobile/views/_common/play_button.dart';
import 'package:lloud_mobile/views/_common/artist_link.dart';
import 'package:lloud_mobile/views/_common/like_button.dart';
import 'package:lloud_mobile/views/_common/more_btn.dart';

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
        child: Card(
          color: LloudTheme.red,
          margin: EdgeInsets.all(8.0),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Stack(
            children: <Widget>[
              Image.network(
                this._song.imageUrl,
                fit: BoxFit.fill,
              ),
              Column(
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            PlayButton(this._song.id, this._song.audioUrl)
                          ])),
                  Container(
                    padding: EdgeInsets.all(12.0),
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(28, 28, 28, 0.6)),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SongTitle(this._song.title),
                                ArtistLink(
                                  this._song.artistId,
                                  this._song.artistName,
                                  txtColor: LloudTheme.white,
                                ),
                              ],
                            )),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Column(
                                  children: <Widget>[
                                    Container(
                                      height: 24,
                                      constraints:
                                          BoxConstraints(maxWidth: 56.0),
                                      child: FlatButton(
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        padding: EdgeInsets.zero,
                                        onPressed: () {},
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                margin:
                                                    EdgeInsets.only(right: 4.0),
                                                child: Icon(
                                                  Icons.favorite,
                                                  size: 16.0,
                                                  color: Color.fromRGBO(
                                                      255, 255, 255, 0.6),
                                                ),
                                              ),
                                              Text(
                                                this
                                                    ._song
                                                    .likesCount
                                                    .toString(),
                                                textAlign: TextAlign.end,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    color: LloudTheme.white),
                                              )
                                            ]),
                                      ),
                                    ),
                                    Container(
                                      height: 24,
                                      constraints:
                                          BoxConstraints(maxWidth: 56.0),
                                      child: MoreButton(this._song),
                                    )
                                  ],
                                ),
                                LikeButton(this._song.id, this._song.isLiked)
                              ],
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
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
