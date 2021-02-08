import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:lloud_mobile/models/portfolio_item.dart';

class Song {
  final int id;
  final String title;
  final int artistId;
  final String artistName;
  final int likesCount;
  final int playsCount;
  final String imageUrl;
  final String audioUrl;
  final bool isLiked;

  const Song({
    @required this.id,
    @required this.title,
    @required this.artistId,
    @required this.artistName,
    @required this.likesCount,
    @required this.playsCount,
    @required this.imageUrl,
    @required this.audioUrl,
    this.isLiked = false,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artistId: json['artists'][0]['id'],
      artistName: json['artists'][0]['name'],
      likesCount: json['__meta__']['likes_count'],
      playsCount: json['__meta__']['plays_count'],
      imageUrl: json['imageFile']['location'],
      audioUrl: json['audioFile']['location'],
      isLiked: (json['__meta__']['liked_by_user'] > 0),
    );
  }

  static List<Song> fromJsonList(List<dynamic> jsonList) {
    List<Song> songs = [];
    jsonList.forEach((json) {
      songs.add(Song.fromJson(json));
    });
    return songs;
  }

  static List<Song> fromPortfolioItemList(List<PortfolioItem> portfolioItems) {
    List<Song> songs = [];
    portfolioItems.forEach((item) {
      songs.add(item.song);
    });
    return songs;
  }
}
