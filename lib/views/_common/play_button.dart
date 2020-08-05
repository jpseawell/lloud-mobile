import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/song_player.dart';

class PlayButton extends StatefulWidget {
  final int _songId;
  final String _audioUrl;

  PlayButton(this._songId, this._audioUrl);

  @override
  _PlayButtonState createState() =>
      _PlayButtonState(this._songId, this._audioUrl);
}

class _PlayButtonState extends State<PlayButton> {
  final int _songId;
  final String _audioUrl;

  _PlayButtonState(this._songId, this._audioUrl);

  Future<void> _playThisSong(BuildContext ctx) async {
    final songPlayer = Provider.of<SongPlayer>(ctx, listen: false);
    await songPlayer.playSong(this._songId, this._audioUrl);
  }

  Future<void> _pauseThisSong(BuildContext ctx) async {
    final songPlayer = Provider.of<SongPlayer>(ctx, listen: false);
    await songPlayer.pauseSong();
  }

  @override
  Widget build(BuildContext context) {
    final roSongPlayer =
        Provider.of<SongPlayer>(context); // Read Only song player
    bool thisSongIsBeingPlayed =
        (roSongPlayer.currentSongId == this._songId && roSongPlayer.isPlaying);

    return FlatButton(
      onPressed: () async => {
        thisSongIsBeingPlayed
            ? await _pauseThisSong(context)
            : await _playThisSong(context)
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
