import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/views/components/play_button.dart';
import 'package:lloud_mobile/views/components/song_info_bar.dart';

class SongWidget extends StatefulWidget {
  final int index;
  final Song song;
  final Function(BuildContext ctx, int index, Song song) onPlayButtonTap;

  SongWidget(this.index, this.song, {this.onPlayButtonTap});

  @override
  _SongWidgetState createState() => _SongWidgetState(this.index, this.song,
      onPlayButtonTap: this.onPlayButtonTap);
}

class _SongWidgetState extends State<SongWidget> {
  final int _index;
  final Song _song;
  final Function(BuildContext ctx, int index, Song song) onPlayButtonTap;

  _SongWidgetState(this._index, this._song, {this.onPlayButtonTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 4, top: 4, right: 4),
      child: AspectRatio(
          aspectRatio: 1 / 1,
          child: Card(
            color: LloudTheme.red,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Stack(
              children: <Widget>[
                Image.network(
                  this._song.imageUrl,
                  fit: BoxFit.fill,
                ),
                Column(
                  children: <Widget>[
                    Expanded(
                        flex: 3,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              PlayButton(
                                this._index,
                                this._song,
                                onTapCB: onPlayButtonTap,
                              )
                            ])),
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration:
                          BoxDecoration(color: Color.fromRGBO(28, 28, 28, 0.6)),
                      child: SongInfoBar(this._song),
                    )
                  ],
                )
              ],
            ),
          )),
    );
  }
}
