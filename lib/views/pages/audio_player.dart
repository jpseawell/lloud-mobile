import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/views/components/song_info_bar.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/audio.dart';
import 'package:lloud_mobile/views/components/audio_bar.dart';

class AudioPlayerPage extends StatelessWidget {
  void onArtistLinkTap(BuildContext ctx) {
    Navigator.pop(ctx);
  }

  @override
  Widget build(BuildContext context) {
    AudioProvider ap = Provider.of<AudioProvider>(context);

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
                                          ap.currentSong.imageUrl +
                                              '?tr=w-300,h-300'),
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
                          ap.currentSong,
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

class DurationBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AudioProvider ap = Provider.of<AudioProvider>(context);
    return StreamBuilder(
        stream: ap.audioPlayer.currentPosition,
        builder: (context, asyncSnapShot) {
          if (!asyncSnapShot.hasData) {
            return Column(
              children: [
                Slider(
                  value: 0,
                  min: 0,
                  max: 1,
                  onChanged: null,
                  label: null,
                  activeColor: LloudTheme.white,
                  inactiveColor: LloudTheme.whiteDark,
                )
              ],
            );
          }

          final Duration current = asyncSnapShot.data;

          if (ap.audioPlayer.current.value == null) {
            return Column(
              children: [Container()],
            );
          }

          final Duration totalDuration =
              ap.audioPlayer.current.value.audio.duration;

          return Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.bottomCenter,
                children: <Widget>[
                  Slider(
                    activeColor: LloudTheme.white,
                    inactiveColor: LloudTheme.whiteDark,
                    value:
                        (current.inMilliseconds / totalDuration.inMilliseconds),
                    min: 0,
                    max: 1,
                    label: null,
                    onChanged: (double value) {
                      double newPos =
                          value * totalDuration.inMilliseconds.toDouble();
                      ap.audioPlayer
                          .seek(new Duration(milliseconds: newPos.toInt()));
                    },
                  ),
                  Container(
                    margin: EdgeInsets.zero,
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          current.toString().substring(2, 7),
                          textAlign: TextAlign.left,
                          style:
                              TextStyle(color: LloudTheme.white, fontSize: 12),
                        ),
                        Text(
                          totalDuration.toString().substring(2, 7),
                          textAlign: TextAlign.right,
                          style:
                              TextStyle(color: LloudTheme.white, fontSize: 12),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          );
        });
  }
}

class PlayerControlsBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AudioProvider ap = Provider.of<AudioProvider>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 48, vertical: 16),
      child: Row(
        children: <Widget>[
          Expanded(
              child: FlatButton(
                  onPressed: () {
                    ap.prevSongOrLoop();
                  },
                  child: Icon(
                    Icons.skip_previous,
                    color: LloudTheme.white,
                    size: 48,
                  ))),
          Expanded(
              // flex: 2,
              child: Container(
            height: 56,
            child: AudioBarPlayButton(),
          )),
          Expanded(
              child: FlatButton(
                  onPressed: () {
                    ap.nextSongOrLoop();
                  },
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
