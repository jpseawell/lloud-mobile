import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:lloud_mobile/views/_common/song_widget.dart';

import '../../models/song.dart';
import '../../util/dal.dart';

import '../_common/h1.dart';

class SongsPage extends StatefulWidget {
  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  Future<List<Song>> futureSongs;
  AudioPlayer audioPlayer = AudioPlayer();

  /// TODO: Fix issues with songs loading
  int total = 17;
  int pageSize = 1;

  Future<List<Song>> _fetchSongs(int offset, int limit) async {
    String songUrl = 'song/' + offset.toString() + '/' + limit.toString();
    final response = await DAL.instance().fetch(songUrl);
    Map<String, dynamic> jsonObj = json.decode(response.body);
    List<dynamic> rawSongs = jsonObj['items'][0];

    List<Song> songsObj = [];
    rawSongs.forEach((song) => songsObj.add(Song.fromJson(song)));
    return songsObj;
  }

  var completers = new List<Completer<Song>>();

  Widget _loadSong(int itemIndex) {
    if (itemIndex >= completers.length) {
      int toLoad = min(total - itemIndex, pageSize);
      completers.addAll(List.generate(toLoad, (index) {
        return new Completer();
      }));
      _fetchSongs(itemIndex, toLoad).then((items) {
        items.asMap().forEach((index, item) {
          completers[itemIndex + index].complete(item);
        });
      }).catchError((error) {
        completers.sublist(itemIndex, itemIndex + toLoad).forEach((completer) {
          completer.completeError(error);
        });
      });
    }

    var future = completers[itemIndex].future;
    return new FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return new Container(
                padding: const EdgeInsets.all(8.0),
                child: new Placeholder(fallbackHeight: 100.0),
              );
            case ConnectionState.done:
              if (snapshot.hasData) {
                return SongWidget(snapshot.data, this.audioPlayer);
              } else if (snapshot.hasError) {
                return new Text(
                  '${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                );
              }
              return new Text('');
            default:
              return new Text('');
          }
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: new ListView.builder(
              itemCount: total,
              itemBuilder: (BuildContext context, int index) =>
                  _loadSong(index))),
    );
  }
}
