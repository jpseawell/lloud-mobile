import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/portfolio_item.dart';
import 'package:lloud_mobile/views/components/artist_link.dart';
import 'package:lloud_mobile/views/components/song_title.dart';

class PortfolioItemWidget extends StatelessWidget {
  final PortfolioItem portfolioItem;
  final Function onPlay;

  PortfolioItemWidget({this.portfolioItem, this.onPlay});

  @override
  Widget build(BuildContext context) {
    final audioPlayer = Provider.of<AudioPlayer>(context);

    return Container(
      height: 88,
      child: PlayerBuilder.isPlaying(
        player: audioPlayer.player,
        builder: (context, isPlaying) {
          final bool isPlayingThisSong =
              (audioPlayer.currentSongId == portfolioItem.song.id && isPlaying);
          return Card(
            semanticContainer: true,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            elevation: 3,
            shadowColor: LloudTheme.black.withOpacity(.25),
            color: (isPlayingThisSong) ? LloudTheme.black : LloudTheme.white,
            child: InkWell(
              splashColor: LloudTheme.black.withAlpha(30),
              onTap: () => onPlay(portfolioItem.song),
              child: Container(
                padding: EdgeInsets.all(4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    albumArt(isPlayingThisSong),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SongTitle(
                          portfolioItem.song.title,
                          color: (isPlayingThisSong)
                              ? LloudTheme.white
                              : LloudTheme.black,
                          size: 22,
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        ArtistLink(
                          portfolioItem.song.artistId,
                          portfolioItem.song.artistName,
                          txtSize: 18,
                          txtColor: (isPlayingThisSong)
                              ? LloudTheme.white
                              : LloudTheme.black,
                        ),
                      ],
                    )),
                    points(isPlayingThisSong)
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget albumArt(bool isPlayingThisSong) {
    return Container(
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
                            portfolioItem.song.imageUrl + '?tr=w-75,h-75'),
                        fit: BoxFit.cover)),
              ),
              Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.all(16),
                  child: SvgPicture.asset(
                    (isPlayingThisSong)
                        ? 'assets/pause.svg'
                        : 'assets/play.svg',
                    color: LloudTheme.white.withOpacity(.85),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Widget points(bool isPlayingThisSong) {
    return Container(
      padding: EdgeInsets.only(
        right: 10,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Points:',
            style: TextStyle(
              color: (isPlayingThisSong) ? LloudTheme.white : LloudTheme.black,
            ),
          ),
          Text(
            "${portfolioItem.points_earned}",
            style: TextStyle(
              fontSize: 20,
              color: (isPlayingThisSong) ? LloudTheme.white : LloudTheme.black,
            ),
          )
        ],
      ),
    );
  }
}
