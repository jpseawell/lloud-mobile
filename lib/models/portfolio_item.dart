import 'package:flutter/foundation.dart';

class PortfolioItem {
  final int songId;
  final String songTitle;
  final String imageUrl;
  final String audioUrl;
  final int points;
  final int artistId;
  final String artistName;

  const PortfolioItem({
    @required this.songId,
    @required this.songTitle,
    @required this.imageUrl,
    @required this.audioUrl,
    @required this.points,
    @required this.artistId,
    @required this.artistName,
  });

  factory PortfolioItem.fromJson(Map<String, dynamic> json) {
    return PortfolioItem(
      songId: json['id'],
      songTitle: json['name'],
      points: json['report']['newLikes'],
      imageUrl: json['img_file'],
      audioUrl: json['audio_file'],
      artistId: json['artist_id'],
      artistName: json['artist'],
    );
  }
}
