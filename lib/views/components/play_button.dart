import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/providers/audio.dart';

class PlayButton extends StatefulWidget {
  final int index;
  final Song song;
  final Function(BuildContext ctx, int index, Song song) onTapCB;

  PlayButton(this.index, this.song, {this.onTapCB});

  @override
  _PlayButtonState createState() =>
      _PlayButtonState(this.index, this.song, onTapCB: this.onTapCB);
}

class _PlayButtonState extends State<PlayButton> {
  final int index;
  final Song song;
  final Function(BuildContext ctx, int index, Song song) onTapCB;

  bool thisSongIsActive = false;
  bool thisSongIsBeingPlayed = false;

  _PlayButtonState(this.index, this.song, {this.onTapCB});

  @override
  Widget build(BuildContext context) {
    AudioProvider ap = Provider.of<AudioProvider>(context);
    bool thisSongIsBeingPlayed = ap.isBeingPlayed(song);

    return FlatButton(
      onPressed: () {
        onTapCB(context, index, song);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            (thisSongIsBeingPlayed) ? 'assets/pause.svg' : 'assets/play.svg',
            width: 80,
            color: LloudTheme.white.withOpacity(.9),
          )
        ],
      ),
    );
  }
}
