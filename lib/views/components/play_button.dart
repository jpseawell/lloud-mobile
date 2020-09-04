import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/providers/audio.dart';

class PlayButton extends StatefulWidget {
  final int index;
  final Song song;

  PlayButton(this.index, this.song);

  @override
  _PlayButtonState createState() => _PlayButtonState(this.index, this.song);
}

class _PlayButtonState extends State<PlayButton> {
  final int index;
  final Song song;
  bool thisSongIsActive = false;
  bool thisSongIsBeingPlayed = false;

  _PlayButtonState(this.index, this.song);

  void play(BuildContext ctx) {
    Provider.of<AudioProvider>(ctx, listen: false).findAndPlay(index);
  }

  void pause(BuildContext ctx) {
    Provider.of<AudioProvider>(ctx, listen: false).pause();
  }

  @override
  Widget build(BuildContext context) {
    AudioProvider ap = Provider.of<AudioProvider>(context);
    thisSongIsActive =
        (ap.currentSong == null) ? false : (ap.currentSong.id == song.id);
    thisSongIsBeingPlayed = ap.isPlaying && thisSongIsActive;

    return FlatButton(
      onPressed: () => {
        if (thisSongIsBeingPlayed)
          {pause(context)}
        else
          {thisSongIsActive ? ap.resume() : play(context)}
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          thisSongIsBeingPlayed
              ? Image.asset('assets/pause.png')
              : Image.asset('assets/play.png')
        ],
      ),
    );
  }
}
