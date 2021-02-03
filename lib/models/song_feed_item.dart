import 'package:flutter/material.dart';
import 'package:lloud_mobile/models/feed_item.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/views/components/song_widget.dart';

class SongFeedItem implements FeedItem {
  final Song song;
  final Function onPlay;

  SongFeedItem(this.song, this.onPlay);

  Widget build(BuildContext context) {
    return SongWidget(song: song, onPlay: onPlay);
  }
}
