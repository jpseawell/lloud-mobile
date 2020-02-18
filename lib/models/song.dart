import 'package:flutter/foundation.dart';

class Song {
  final int id;
  final String title;
  final String artistId;
  final String artistName;
  final int likesCount;
  final String imageUrl;
  final String audioUrl;
  final bool isLiked;

  const Song({
    @required this.id,
    @required this.title,
    @required this.artistId,
    @required this.artistName,
    @required this.likesCount,
    @required this.imageUrl,
    @required this.audioUrl,
    @required this.isLiked,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artistId: json['artistId'],
      artistName: json['artistName'],
      likesCount: json['likesCount'],
      imageUrl: json['imageUrl'],
      audioUrl: json['audioUrl'],
      isLiked: json['isLiked'],
    );
  }
}
