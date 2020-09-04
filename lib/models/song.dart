import 'package:flutter/foundation.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

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
    @required this.isLiked,
  });

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      id: json['id'],
      title: json['title'],
      artistId: json['artists'][0]['id'],
      artistName: json['artists'][0]['name'],
      likesCount: json['likesCount'],
      playsCount: json['playsCount'],
      imageUrl: json['imageFile']['location'],
      audioUrl: json['audioFile']['location'],
      isLiked: json['likedByUser'],
    );
  }

  Audio toAudio() {
    return Audio.network(this.audioUrl,
        metas: Metas(
            title: this.title,
            artist: this.artistName,
            image: MetasImage.network(this.imageUrl)));
  }
}
