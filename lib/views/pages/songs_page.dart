import 'dart:convert';

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

  Future<List<Song>> fetchSongs() async {
    final response = await DAL.instance().fetch('song/page/1');
    Map<String, dynamic> jsonObj = json.decode(response.body);
    List<dynamic> rawSongs = jsonObj['items'][0];

    List<Song> songsObj = [];
    rawSongs.forEach((song) => songsObj.add(Song.fromJson(song)));
    return songsObj;
  }

  @override
  void initState() {
    super.initState();
    futureSongs = fetchSongs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: ListView(
          children: <Widget>[
            FutureBuilder<List<Song>>(
              future: futureSongs,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  // snapshot.data == our list of songs
                  // TODO: Show song widgets
                  // return Text(snapshot.data[0].title);
                  return SongWidget(snapshot.data[0]);
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                }

                // By default, show a loading spinner.
                return CircularProgressIndicator();
              },
            )
          ],
        ),
      )),
    );
  }
}
