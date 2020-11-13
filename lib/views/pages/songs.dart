import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/providers/audio.dart';
import 'package:lloud_mobile/util/dal.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/views/components/song_widget.dart';

class SongsPage extends StatefulWidget {
  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  ScrollController scrollController;
  List<Song> songs = <Song>[];
  bool isFetching = false;
  int currentPage = 1;

  @override
  Widget build(BuildContext ctx) {
    if (songs.length == 0 && !isFetching) {
      fetchSongs(ctx, currentPage);
    }

    return Scaffold(
      backgroundColor: LloudTheme.blackLight,
      body: SafeArea(
          child: RefreshIndicator(
              color: LloudTheme.red,
              backgroundColor: LloudTheme.black,
              child: NotificationListener<ScrollNotification>(
                child: Stack(children: <Widget>[
                  songWidgetBuilder(),
                  loader(),
                ]),
                onNotification: (ScrollNotification scroll) {
                  if ((scroll.metrics.pixels ==
                          scroll.metrics.maxScrollExtent) &&
                      !isFetching) {
                    fetchSongs(ctx, currentPage);
                  }
                },
              ),
              onRefresh: refresh)),
    );
  }

  Future<void> refresh() async {
    setState(() {
      songs = <Song>[];
      currentPage = 1;
    });
  }

  Future<void> fetchSongs(BuildContext ctx, int requestedPage) async {
    setState(() {
      isFetching = !isFetching;
    });

    String url = 'songs?page=' + requestedPage.toString();
    final response = await DAL.instance().fetch(url);

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedResponse = json.decode(response.body);
      List<Song> tmpSongs = [];
      decodedResponse['data']['songs']
          .forEach((song) => tmpSongs.add(Song.fromJson(song)));

      songs.addAll(tmpSongs);

      AudioProvider ap = Provider.of<AudioProvider>(ctx, listen: false);

      /**
       * NOTE:
       * If the loaded playlist is from the songs
       * page then keep adding songs from the feed
       * 
       * Otherwise, leave the playlist alone
       */
      if (ap.playlistKey == null || ap.playlistKey.contains('songs')) {
        ap.playlistKey = getPlaylistKey();
        await ap.addSongsToPlaylist(tmpSongs);
      }

      setState(() {
        isFetching = !isFetching;
        currentPage += 1;
      });
    } else {
      // TODO: err
    }
  }

  String getPlaylistKey() {
    return 'songs:$currentPage';
  }

  Widget songWidgetBuilder() {
    return ListView.builder(
        controller: scrollController,
        itemCount: songs.length,
        itemBuilder: (context, i) {
          return buildSongWidget(i, songs[i]);
        });
  }

  Widget buildSongWidget(int index, Song song) {
    return SongWidget(
      index,
      song,
      onPlayButtonTap: playSong,
    );
  }

  void playSong(BuildContext ctx, int index, Song song) {
    AudioProvider ap = Provider.of<AudioProvider>(context, listen: false);
    bool thisSongIsBeingPlayed = ap.isBeingPlayed(song);
    bool thisSongIsActive = ap.isActive(song);

    if (ap.playlistKey != getPlaylistKey()) {
      ap.setPlaylist(getPlaylistKey(), songs);
    }

    if (thisSongIsBeingPlayed) {
      ap.pause();
    } else {
      thisSongIsActive ? ap.resume() : ap.findAndPlay(index);
    }
  }

  Widget loader() {
    return isFetching
        ? Align(
            child: Container(
              width: 70.0,
              height: 70.0,
              child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Center(
                      child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(LloudTheme.red),
                  ))),
            ),
            alignment: FractionalOffset.bottomCenter,
          )
        : SizedBox(
            width: 0.0,
            height: 0.0,
          );
  }
}