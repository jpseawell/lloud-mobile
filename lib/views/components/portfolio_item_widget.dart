// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

// import 'package:lloud_mobile/config/lloud_theme.dart';
// import 'package:lloud_mobile/providers/song_player.dart';

// import '../../models/portfolio_item.dart';

// import '../_common/artist_link.dart';

// class PortfolioItemWidget extends StatefulWidget {
//   final PortfolioItem _portfolioItem;

//   PortfolioItemWidget(this._portfolioItem);

//   @override
//   _PortfolioItemWidgetState createState() =>
//       _PortfolioItemWidgetState(this._portfolioItem);
// }

// class _PortfolioItemWidgetState extends State<PortfolioItemWidget> {
//   final PortfolioItem _portfolioItem;

//   _PortfolioItemWidgetState(this._portfolioItem);

//   Future<void> _playThisSong(BuildContext ctx) async {
//     final songPlayer = Provider.of<SongPlayer>(ctx, listen: false);
//     await songPlayer.playSong(
//         this._portfolioItem, this._portfolioItem.audioUrl);
//   }

//   Future<void> _pauseThisSong(BuildContext ctx) async {
//     final songPlayer = Provider.of<SongPlayer>(ctx, listen: false);
//     await songPlayer.pauseSong();
//   }

//   @override
//   Widget build(BuildContext context) {
//     final roSongPlayer =
//         Provider.of<SongPlayer>(context); // Read Only song player
//     bool thisSongIsBeingPlayed =
//         (roSongPlayer.currentSong.id == this._portfolioItem.songId &&
//             roSongPlayer.isPlaying);

//     return FlatButton(
//         color: (thisSongIsBeingPlayed) ? LloudTheme.black : Color(0x00000000),
//         textColor:
//             (thisSongIsBeingPlayed) ? LloudTheme.white : LloudTheme.black,
//         padding: EdgeInsets.zero,
//         onPressed: () async {
//           thisSongIsBeingPlayed
//               ? await _pauseThisSong(context)
//               : await _playThisSong(context);
//         },
//         child: Container(
//           child: Row(children: <Widget>[
//             Expanded(
//                 flex: 1,
//                 child: AspectRatio(
//                   aspectRatio: 1 / 1,
//                   child: Container(
//                       decoration: new BoxDecoration(
//                           image: new DecorationImage(
//                               image: new NetworkImage(
//                                   this._portfolioItem.imageUrl),
//                               fit: BoxFit.cover)),
//                       alignment: Alignment.bottomLeft,
//                       padding: EdgeInsets.all(16.0)),
//                 )), // Album art/audio url/song id
//             Expanded(
//                 flex: 2,
//                 child: Container(
//                   padding: EdgeInsets.all(16.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: <Widget>[
//                       SingleChildScrollView(
//                         scrollDirection: Axis.horizontal,
//                         child: Text("${this._portfolioItem.songTitle}",
//                             style: TextStyle(
//                                 fontSize: 24,
//                                 fontWeight: FontWeight.bold,
//                                 fontFamily: 'Raleway')),
//                       ),
//                       ArtistLink(
//                         this._portfolioItem.artistId,
//                         this._portfolioItem.artistName,
//                         txtColor: (thisSongIsBeingPlayed)
//                             ? LloudTheme.white
//                             : LloudTheme.black,
//                       )
//                     ],
//                   ),
//                 )),
//             Expanded(
//                 flex: 1,
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: <Widget>[
//                     Text('Points:'),
//                     Text(
//                       "${this._portfolioItem.points}",
//                       style: TextStyle(fontSize: 20),
//                     )
//                   ],
//                 )), // Song title, artist name/link, points scored so far
//           ]),
//         ));
//   }
// }
