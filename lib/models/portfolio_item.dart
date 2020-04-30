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
      songId: json['song']['id'],
      songTitle: json['song']['title'],
      points: json['pointsEarned'],
      imageUrl: json['song']['imageFile']['location'],
      audioUrl: json['song']['audioFile']['location'],
      artistId: json['song']['artists'][0]['id'],
      artistName: json['song']['artists'][0]['name'],
    );
  }
}
