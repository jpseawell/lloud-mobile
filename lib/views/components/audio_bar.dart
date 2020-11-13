import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/providers/audio.dart';

class AudioBar extends StatefulWidget {
  @override
  _AudioBarState createState() => _AudioBarState();
}

class _AudioBarState extends State<AudioBar> {
  void openAudioPlayer(BuildContext context) {
    Navigator.pushNamed(context, Routes.audio_player);
  }

  @override
  Widget build(BuildContext context) {
    AudioProvider ap = Provider.of<AudioProvider>(context);
    return Container(
      color: LloudTheme.black,
      height: 64,
      child: Row(
        children: <Widget>[
          Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: InkWell(
                    child: Hero(
                        tag: 'current-cover',
                        child: AspectRatio(
                          aspectRatio: 1 / 1,
                          child: Container(
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      image: NetworkImage(
                                          ap.currentSong.imageUrl +
                                              '?tr=w-100,h-100'),
                                      fit: BoxFit.cover)),
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.all(16.0)),
                        )),
                    onTap: () {
                      openAudioPlayer(context);
                    },
                  ))
            ],
          ),
          Expanded(
              flex: 4,
              child: Container(
                  padding: EdgeInsets.all(8),
                  child: InkWell(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Text(ap.currentSong.title,
                                style: TextStyle(
                                    color: LloudTheme.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Raleway'))),
                        Text(
                          ap.currentSong.artistName,
                          style: TextStyle(
                              fontSize: 18,
                              color: LloudTheme.white,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                    onTap: () {
                      openAudioPlayer(context);
                    },
                  ))),
          Column(
            children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    child: AudioBarPlayButton(),
                  ))
            ],
          ),
        ],
      ),
    );
  }
}

class AudioBarPlayButton extends StatelessWidget {
  void play(BuildContext ctx) {
    Provider.of<AudioProvider>(ctx, listen: false).resume();
  }

  void pause(BuildContext ctx) {
    Provider.of<AudioProvider>(ctx, listen: false).pause();
  }

  @override
  Widget build(BuildContext context) {
    AudioProvider ap = Provider.of<AudioProvider>(context);
    return FlatButton(
      onPressed: () => {ap.isPlaying ? pause(context) : play(context)},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SvgPicture.asset(
            (ap.isPlaying) ? 'assets/pause.svg' : 'assets/play.svg',
            width: 48,
          )
        ],
      ),
    );
  }
}
