import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/views/components/play_button.dart';
import 'package:lloud_mobile/views/components/song_info_bar.dart';

class SongWidget extends StatelessWidget {
  final Song song;
  final Function onPlay;

  SongWidget({this.song, this.onPlay});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 4, top: 4, right: 4),
      child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Card(
            color: LloudTheme.black,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image:
                              NetworkImage(song.imageUrl + '?tr=w-500,h-500'),
                          fit: BoxFit.cover)),
                ),
                Column(
                  children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              PlayButton(
                                song: song,
                                onPlay: onPlay,
                              )
                            ])),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration:
                          BoxDecoration(color: Color.fromRGBO(28, 28, 28, 0.6)),
                      child: SongInfoBar(song),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
