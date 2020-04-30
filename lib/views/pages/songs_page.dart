import 'dart:convert';
import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lloud_mobile/views/_common/song_widget.dart';

import '../../models/song.dart';
import '../../util/dal.dart';

class SongsPage extends StatefulWidget {
  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  ScrollController controller;
  final _songs = <Song>[];
  bool isFetching = true;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    fetchSongs(currentPage).then((result) {
      controller = new ScrollController()..addListener(_scrollListener);
    });
  }

  void _scrollListener() {
    if (controller.position.pixels == controller.position.maxScrollExtent) {
      startLoader();
    }
  }

  void startLoader() {
    setState(() {
      isFetching = !isFetching;
      fetchSongs(currentPage);
    });
  }

  Future<void> fetchSongs(int requestedPage) async {
    String url = 'songs/' + requestedPage.toString();
    final response = await DAL.instance().fetch(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      List<Song> songs = [];
      decodedResponse['data'].forEach((song) => songs.add(Song.fromJson(song)));

      _songs.addAll(songs);

      setState(() {
        isFetching = !isFetching;
        currentPage += 1;
      });
    } else {
      // err
      print('ERR:');
      print(response.body.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: new Stack(children: <Widget>[
        _songWidgetBuilder(),
        _loader(),
      ])),
    );
  }

  Widget _songWidgetBuilder() {
    return new ListView.builder(
        controller: controller,
        itemCount: _songs.length,
        itemBuilder: (context, i) {
          return _buildSongWidget(_songs[i]);
        });
  }

  Widget _buildSongWidget(Song song) {
    return SongWidget(song);
  }

  Widget _loader() {
    return isFetching
        ? new Align(
            child: new Container(
              width: 70.0,
              height: 70.0,
              child: new Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: new Center(child: new CircularProgressIndicator())),
            ),
            alignment: FractionalOffset.bottomCenter,
          )
        : new SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }
}
