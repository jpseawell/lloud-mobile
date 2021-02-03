import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/views/components/artist_link.dart';
import 'package:lloud_mobile/views/components/like_button.dart';
import 'package:lloud_mobile/views/components/more_btn.dart';
import 'package:lloud_mobile/views/components/song_title.dart';

class SongInfoBar extends StatelessWidget {
  final Song song;
  final Function artistLinkCB;

  SongInfoBar(this.song, {this.artistLinkCB});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SongTitle(
                  song.title,
                  size: 26,
                ),
                SizedBox(
                  height: 2,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ArtistLink(
                      song.artistId,
                      song.artistName,
                      txtColor: LloudTheme.white,
                      preLinkCB: artistLinkCB,
                    )
                  ],
                )
              ],
            )),
        Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(right: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[SongStats(song), MoreButton(song)],
                  ),
                ),
                LikeButton(songId: song.id)
              ],
            )
          ],
        )
      ],
    );
  }
}

class SongStats extends StatefulWidget {
  final Song song;
  final Key key;
  Color color;

  SongStats(this.song, {this.key, this.color});

  @override
  _SongStatsState createState() =>
      _SongStatsState(this.song, color: this.color);
}

class _SongStatsState extends State<SongStats> {
  final Song _song;
  Color color;

  _SongStatsState(this._song, {this.color});

  final List<String> _statKeys = ['plays', 'likes'];
  Timer timer;
  int _activeIndex = 0;

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  int randomNumberOfSeconds(int min, int max) {
    Random random = new Random();
    int min = 5;
    int max = 10;
    double result = random.nextDouble() * (max - min) + min;

    return result.floor();
  }

  void startTimer() {
    timer = Timer.periodic(new Duration(seconds: randomNumberOfSeconds(5, 10)),
        (timer) {
      showNextStat();
    });
  }

  void showNextStat() {
    int newIndex = _activeIndex + 1;

    if (newIndex >= _statKeys.length) {
      newIndex = 0;
    }

    setState(() {
      _activeIndex = newIndex;
    });
  }

  String formatNumber(int stat) {
    String statStr = stat.toString();

    if (statStr.length <= 3) {
      return statStr;
    }

    if (statStr.length > 6) {
      return '${statStr.substring(0, (statStr.length - 6))}M';
    }

    return '${statStr.substring(0, (statStr.length - 3))}K';
  }

  @override
  Widget build(BuildContext context) {
    final Duration transition = Duration(milliseconds: 500);

    return ButtonTheme(
      height: 24,
      minWidth: 16,
      padding: EdgeInsets.zero,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      child: FlatButton(
          onPressed: () {
            showNextStat();
          },
          child: Container(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                AnimatedOpacity(
                  opacity: (_statKeys[_activeIndex] == 'plays') ? 1.0 : 0.0,
                  duration: transition,
                  child: PlaysStat(
                    formatNumber(_song.playsCount),
                    color: color,
                  ),
                ),
                AnimatedOpacity(
                  opacity: (_statKeys[_activeIndex] == 'likes') ? 1.0 : 0.0,
                  duration: transition,
                  child: LikesStat(
                    formatNumber(_song.likesCount),
                    color: color,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}

class LikesStat extends StatelessWidget {
  final String likesCount;
  final Color color;

  LikesStat(this.likesCount, {this.color});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Container(
        margin: EdgeInsets.only(right: 4.0),
        child: Icon(
          Icons.favorite,
          size: 16.0,
          color: (color == null)
              ? Color.fromRGBO(255, 255, 255, 0.6)
              : color.withOpacity(.6),
        ),
      ),
      Text(
        likesCount,
        textAlign: TextAlign.end,
        style: TextStyle(
            fontWeight: FontWeight.w300, color: color ?? LloudTheme.white),
      )
    ]);
  }
}

class PlaysStat extends StatelessWidget {
  final String playsCount;
  final Color color;

  PlaysStat(this.playsCount, {this.color});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      Container(
        margin: EdgeInsets.only(right: 1.0),
        child: Icon(
          Icons.play_arrow_rounded,
          color: (color == null)
              ? Color.fromRGBO(255, 255, 255, 0.6)
              : color.withOpacity(.6),
        ),
      ),
      Text(
        playsCount,
        textAlign: TextAlign.end,
        style: TextStyle(
            fontWeight: FontWeight.w300, color: color ?? LloudTheme.white),
      )
    ]);
  }
}
