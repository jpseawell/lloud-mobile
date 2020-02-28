import 'package:flutter/foundation.dart';

class Song {
  final int id;
  final String title;
  final int artistId;
  final String artistName;
  final int likesCount;
  final String imageUrl;
  final String audioUrl;
  // final bool isLiked;

  const Song({
    @required this.id,
    @required this.title,
    @required this.artistId,
    @required this.artistName,
    @required this.likesCount,
    @required this.imageUrl,
    @required this.audioUrl,
    // @required this.isLiked,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['song_id'],
      title: json['song_name'],
      artistId: json['artist_id'],
      artistName: json['artist_name'],
      likesCount: json['total_likes'],
      imageUrl: json['img_location'],
      audioUrl: json['audio_location'],
      // isLiked: json['isLiked'],
    );
  }
}
