import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/models/song.dart';

class PlayButton extends StatelessWidget {
  final Song song;
  final Function onPlay;

  PlayButton({this.song, this.onPlay});

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayer>(context);

    return FlatButton(
      onPressed: () => onPlay(song),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            (audioPlayer.currentSongId == song.id && audioPlayer.isPlaying)
                ? 'assets/pause.svg'
                : 'assets/play.svg',
            width: 80,
            color: LloudTheme.white.withOpacity(.9),
          )
        ],
      ),
    );
  }
}
