import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/providers/audio.dart';
import 'package:lloud_mobile/views/components/like_button.dart';
import 'package:lloud_mobile/views/components/more_btn.dart';
import 'package:lloud_mobile/views/components/song_info_bar.dart';
import 'package:lloud_mobile/views/components/song_title.dart';

class SongWidgetSmall extends StatefulWidget {
  final int index;
  final Song song;
  final Function(BuildContext ctx, int index, Song song) onTapCB;

  SongWidgetSmall(this.index, this.song, {this.onTapCB});

  @override
  _SongWidgetSmallState createState() =>
      _SongWidgetSmallState(this.index, this.song, onTapCB: this.onTapCB);
}

class _SongWidgetSmallState extends State<SongWidgetSmall> {
  final int _index;
  final Song _song;
  final Function(BuildContext ctx, int index, Song song) onTapCB;
  bool _thisSongIsBeingPlayed = false;

  _SongWidgetSmallState(this._index, this._song, {this.onTapCB});

  bool isBeingPlayed(AudioProvider ap) {
    if (ap.currentSong == null) {
      return false;
    }

    bool thisSongIsActive = ap.currentSong.id == _song.id;
    bool result = ap.isPlaying && thisSongIsActive;

    return result;
  }

  @override
  Widget build(BuildContext context) {
    AudioProvider ap = Provider.of<AudioProvider>(context);
    _thisSongIsBeingPlayed = isBeingPlayed(ap);

    return Container(
      height: 88,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 5,
        color: LloudTheme.white,
        child: InkWell(
          splashColor: LloudTheme.red.withAlpha(30),
          onTap: () {
            onTapCB(context, _index, _song);
          },
          child: Stack(
            children: [
              Row(
                children: [
                  Expanded(
                      child: Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: NetworkImage(_song.imageUrl),
                            fit: BoxFit.cover)),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                          color: _thisSongIsBeingPlayed
                              ? LloudTheme.white.withOpacity(.75)
                              : LloudTheme.black.withOpacity(.75)),
                    ),
                  ))
                ],
              ),
              Container(
                padding: EdgeInsets.all(4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 8),
                      child: AspectRatio(
                        aspectRatio: 1 / 1,
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                _song.imageUrl,
                                fit: BoxFit.fill,
                              ),
                              Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(16),
                                child: _thisSongIsBeingPlayed
                                    ? Image.asset('assets/pause.png')
                                    : Image.asset('assets/play.png'),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SongTitle(
                          _song.title,
                          color: _thisSongIsBeingPlayed
                              ? LloudTheme.black
                              : LloudTheme.white,
                          size: 28,
                        ),
                        Text(
                          _song.artistName,
                          style: TextStyle(
                              fontSize: 20,
                              color: _thisSongIsBeingPlayed
                                  ? LloudTheme.black
                                  : LloudTheme.white,
                              fontWeight: FontWeight.w300),
                        ),
                      ],
                    )),
                    Container(
                      margin: EdgeInsets.only(right: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          SongStats(
                            _song,
                            key: UniqueKey(),
                            color: _thisSongIsBeingPlayed
                                ? LloudTheme.black
                                : LloudTheme.white,
                          ),
                          MoreButton(
                            _song,
                            color: _thisSongIsBeingPlayed
                                ? LloudTheme.black
                                : LloudTheme.white,
                          )
                        ],
                      ),
                    ),
                    Container(
                      width: 56,
                      height: 56,
                      margin: EdgeInsets.only(right: 4),
                      child: LikeButton(
                          songId: _song.id, likedByUser: _song.isLiked),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
