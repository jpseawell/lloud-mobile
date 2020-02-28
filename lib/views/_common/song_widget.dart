import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

import '../../util/dal.dart';

import '../../models/song.dart';

class SongWidget extends StatefulWidget {
  final Song song;
  final AudioPlayer audioPlayer;

  SongWidget(this.song, this.audioPlayer);

  @override
  _SongWidgetState createState() =>
      _SongWidgetState(this.song, this.audioPlayer);
}

class _SongWidgetState extends State<SongWidget> {
  final Song _song;
  final AudioPlayer _audioPlayer;
  bool _playingAudio = false;
  bool _likedSong = false;
  int _currentLikes;

  _SongWidgetState(this._song, this._audioPlayer);

  @override
  void initState() {
    super.initState();
    _currentLikes = this._song.likesCount;
  }

  Future<void> _likeSong() async {
    if (_likedSong) {
      return;
    }

    final response = await DAL
        .instance()
        .post('song/' + this._song.id.toString() + '/like', {});

    if (response.statusCode == 201) {
      setState(() {
        _likedSong = true;
        _currentLikes = _currentLikes + 1;
      });
    }
  }

  Future<void> _togglePlayAudio() async {
    if (this._playingAudio) {
      int result = await this._audioPlayer.stop();
      if (result == 1) {
        setState(() {
          _playingAudio = false;
        });
      }
      return;
    }

    int result = await this._audioPlayer.play(this._song.audioUrl);
    if (result == 1) {
      setState(() {
        _playingAudio = true;
      });
    }
  }

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
                        FlatButton(
                            onPressed: () async => {await _togglePlayAudio()},
                            child: Icon(
                              _playingAudio ? Icons.stop : Icons.play_arrow,
                              size: 128,
                              color: Color.fromRGBO(255, 255, 255, .75),
                            ))
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
                            RaisedButton(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16.0, vertical: 12.0),
                              textColor: LloudTheme.white,
                              color: LloudTheme.red,
                              onPressed: () async => {await _likeSong()},
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    flex: 1,
                                    child: Icon(_likedSong
                                        ? Icons.favorite
                                        : Icons.favorite_border),
                                  ),
                                  Expanded(
                                      flex: 2,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Text(_currentLikes.toString(),
                                              style: TextStyle(fontSize: 20))
                                        ],
                                      ))
                                ],
                              ),
                            )
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
