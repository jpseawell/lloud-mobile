import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/portfolio_item.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/providers/audio.dart';
import 'package:lloud_mobile/views/components/artist_link.dart';
import 'package:lloud_mobile/views/components/song_title.dart';

class PortfolioItemWidget extends StatefulWidget {
  final int index;
  final PortfolioItem portfolioItem;
  final Function(BuildContext ctx, int index, Song song) onTapCB;

  PortfolioItemWidget({this.index, this.portfolioItem, this.onTapCB});

  @override
  _PortfolioItemWidgetState createState() => _PortfolioItemWidgetState(
      index: this.index,
      portfolioItem: this.portfolioItem,
      onTapCB: this.onTapCB);
}

class _PortfolioItemWidgetState extends State<PortfolioItemWidget> {
  final PortfolioItem portfolioItem;
  final int index;
  final Function(BuildContext ctx, int index, Song song) onTapCB;
  bool _thisSongIsBeingPlayed = false;

  _PortfolioItemWidgetState({this.index, this.portfolioItem, this.onTapCB});

  @override
  Widget build(BuildContext context) {
    AudioProvider ap = Provider.of<AudioProvider>(context);
    _thisSongIsBeingPlayed = ap.isBeingPlayed(portfolioItem.song);

    return Container(
      height: 88,
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 3,
        shadowColor: LloudTheme.black.withOpacity(.25),
        color: (_thisSongIsBeingPlayed) ? LloudTheme.black : LloudTheme.white,
        child: InkWell(
          splashColor: LloudTheme.black.withAlpha(30),
          onTap: () {
            onTapCB(context, index, portfolioItem.song);
          },
          child: Container(
            padding: EdgeInsets.all(4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                albumArt(),
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SongTitle(
                      portfolioItem.song.title,
                      color: (_thisSongIsBeingPlayed)
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
                      txtColor: (_thisSongIsBeingPlayed)
                          ? LloudTheme.white
                          : LloudTheme.black,
                    ),
                  ],
                )),
                points()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget albumArt() {
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
                    (_thisSongIsBeingPlayed)
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

  Widget points() {
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
              color: (_thisSongIsBeingPlayed)
                  ? LloudTheme.white
                  : LloudTheme.black,
            ),
          ),
          Text(
            "${portfolioItem.points_earned}",
            style: TextStyle(
              fontSize: 20,
              color: (_thisSongIsBeingPlayed)
                  ? LloudTheme.white
                  : LloudTheme.black,
            ),
          )
        ],
      ),
    );
  }
}
