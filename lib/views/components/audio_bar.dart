import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/routes.dart';
import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class AudioBar extends StatefulWidget {
  @override
  _AudioBarState createState() => _AudioBarState();
}

class _AudioBarState extends State<AudioBar> {
  @override
  Widget build(BuildContext context) {
    final currentSong = Provider.of<AudioPlayer>(context).currentSong;
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
                                          '${currentSong.imageUrl}?tr=w-100,h-100'),
                                      fit: BoxFit.cover)),
                              alignment: Alignment.bottomLeft,
                              padding: EdgeInsets.all(16.0)),
                        )),
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.audio_player),
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
                            child: Text(currentSong.title,
                                style: TextStyle(
                                    color: LloudTheme.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Raleway'))),
                        Text(
                          currentSong.artistName,
                          style: TextStyle(
                              fontSize: 18,
                              color: LloudTheme.white,
                              fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                    onTap: () =>
                        Navigator.pushNamed(context, Routes.audio_player),
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
  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayer>(context);

    return FlatButton(
      onPressed: () async => audioPlayer.toggle(),
      child: SvgPicture.asset(
        (audioPlayer.isPlaying) ? 'assets/pause.svg' : 'assets/play.svg',
        color: LloudTheme.white.withOpacity(.9),
      ),
    );
  }
}
