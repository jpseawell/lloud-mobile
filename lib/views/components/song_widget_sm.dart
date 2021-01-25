import 'dart:ui';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/views/components/like_button.dart';
import 'package:lloud_mobile/views/components/more_btn.dart';
import 'package:lloud_mobile/views/components/song_info_bar.dart';
import 'package:lloud_mobile/views/components/song_title.dart';

class SongWidgetSmall extends StatelessWidget {
  final Song song;
  final Function onPlay;

  SongWidgetSmall({this.song, this.onPlay});

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayer>(context);

    return Container(
      height: 88,
      child: PlayerBuilder.isPlaying(
          player: audioPlayer.player,
          builder: (context, isPlaying) {
            final bool isPlayingThisSong =
                (audioPlayer.currentSongId == song.id && isPlaying);

            return Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              elevation: 5,
              color: LloudTheme.white,
              child: InkWell(
                splashColor: LloudTheme.red.withAlpha(30),
                onTap: () => onPlay(song),
                child: Stack(
                  children: [
                    Row(
                      children: [
                        Expanded(
                            child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: NetworkImage(
                                      song.imageUrl + '?tr=w-100,h-100'),
                                  fit: BoxFit.cover)),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                                color: isPlayingThisSong
                                    ? LloudTheme.white.withOpacity(.75)
                                    : LloudTheme.black.withOpacity(.75)),
                          ),
                        ))
                      ],
                    ),
                    Container(
                      padding: EdgeInsets.all(4),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.only(right: 8),
                            child: AspectRatio(
                              aspectRatio: 1 / 1,
                              child: Card(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Stack(
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  song.imageUrl +
                                                      '?tr=w-75,h-75'),
                                              fit: BoxFit.cover)),
                                    ),
                                    Container(
                                        alignment: Alignment.center,
                                        padding: EdgeInsets.all(16),
                                        child: SvgPicture.asset(
                                          (isPlayingThisSong)
                                              ? 'assets/pause.svg'
                                              : 'assets/play.svg',
                                          color:
                                              LloudTheme.white.withOpacity(.85),
                                        ))
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SongTitle(
                                song.title,
                                color: isPlayingThisSong
                                    ? LloudTheme.black
                                    : LloudTheme.white,
                                size: 24,
                              ),
                              Text(
                                song.artistName,
                                style: TextStyle(
                                    fontSize: 18,
                                    color: isPlayingThisSong
                                        ? LloudTheme.black
                                        : LloudTheme.white,
                                    fontWeight: FontWeight.w300),
                              ),
                            ],
                          )),
                          Container(
                            margin: EdgeInsets.only(right: 16.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                SongStats(
                                  song,
                                  key: UniqueKey(),
                                  color: isPlayingThisSong
                                      ? LloudTheme.black
                                      : LloudTheme.white,
                                ),
                                MoreButton(
                                  song,
                                  color: isPlayingThisSong
                                      ? LloudTheme.black
                                      : LloudTheme.white,
                                )
                              ],
                            ),
                          ),
                          Container(
                            width: 56,
                            height: 56,
                            margin: EdgeInsets.only(right: 4),
                            child: LikeButton(
                                songId: song.id, likedByUser: song.isLiked),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }
}
