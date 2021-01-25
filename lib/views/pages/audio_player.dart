import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/views/components/duration_bar.dart';
import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/views/components/song_info_bar.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/views/components/audio_bar.dart';

class AudioPlayerPage extends StatelessWidget {
  void onArtistLinkTap(BuildContext ctx) {
    Navigator.pop(ctx);
  }

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayer>(context);

    return GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        if (details.delta.dy > 10) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: LloudTheme.black,
        body: SafeArea(
            child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  ButtonTheme(
                    minWidth: 16,
                    padding: EdgeInsets.zero,
                    height: 48,
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    child: FlatButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          color: LloudTheme.white,
                          size: 32,
                        )),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: <Widget>[
                    Expanded(
                        flex: 1,
                        child: Hero(
                          tag: 'current-cover',
                          child: AspectRatio(
                            aspectRatio: 1 / 1,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          '${audioPlayer.currentAudio.metas.extra['imageUrl']}?tr=w-300,h-300'),
                                      fit: BoxFit.cover)),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                      child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: SongInfoBar(
                          audioPlayer.currentSong,
                          artistLinkCB: onArtistLinkTap,
                        ),
                      ),
                      DurationBar(),
                      PlayerControlsBar()
                    ],
                  ))
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}

class PlayerControlsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayer>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      child: Row(
        children: <Widget>[
          Expanded(
              child: FlatButton(
                  onPressed: () => audioPlayer.prev(),
                  child: Icon(
                    Icons.skip_previous,
                    color: LloudTheme.white,
                    size: 48,
                  ))),
          Expanded(
              child: Container(
            height: 56,
            child: AudioBarPlayButton(),
          )),
          Expanded(
              child: FlatButton(
                  onPressed: () => audioPlayer.next(),
                  child: Icon(
                    Icons.skip_next,
                    color: LloudTheme.white,
                    size: 48,
                  ))),
        ],
      ),
    );
  }
}
