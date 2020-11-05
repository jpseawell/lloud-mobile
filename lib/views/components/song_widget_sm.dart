import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

  @override
  Widget build(BuildContext context) {
    AudioProvider ap = Provider.of<AudioProvider>(context);
    _thisSongIsBeingPlayed = ap.isBeingPlayed(_song);

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
                            image: NetworkImage(
                                _song.imageUrl + '?tr=w-100,h-100'),
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
                              Container(
                                decoration: BoxDecoration(
                                    image: DecorationImage(
                                        image: NetworkImage(
                                            _song.imageUrl + '?tr=w-75,h-75'),
                                        fit: BoxFit.cover)),
                              ),
                              Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.all(16),
                                  child: SvgPicture.asset(
                                    (_thisSongIsBeingPlayed)
                                        ? 'assets/pause.svg'
                                        : 'assets/play.svg',
                                    color: LloudTheme.white.withOpacity(.85),
                                  ))
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
                          size: 24,
                        ),
                        Text(
                          _song.artistName,
                          style: TextStyle(
                              fontSize: 18,
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
