import 'package:flutter/foundation.dart';

import 'package:lloud_mobile/models/artist.dart';
import 'package:lloud_mobile/models/song.dart';

class ArtistProfile {
  final Artist artist;
  final List<Song> songs;
  final int likes;
  final int plays;
  final String profileImg;

  const ArtistProfile({
    @required this.artist,
    @required this.songs,
    @required this.likes,
    @required this.plays,
    @required this.profileImg,
  });

  factory ArtistProfile.fromJson(Map<String, dynamic> json) {
    List<Song> songs = [];
    for (var song in json['songs']) {
      song['artists'] = [json['artist']];
      songs.add(Song.fromJson(song));
    }

    return ArtistProfile(
        artist: Artist.fromJson(json['artist']),
        songs: songs,
        likes: json['likes'],
        plays: json['plays'],
        profileImg: json['profileImg']);
  }
}
