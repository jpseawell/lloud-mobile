import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';

import 'package:lloud_mobile/models/ad_feed_item.dart';
import 'package:lloud_mobile/models/song_feed_item.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/services/error_reporting.dart';
import 'package:lloud_mobile/services/songs_service.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/models/feed_item.dart';
import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/providers/songs.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class SongsPage extends StatefulWidget {
  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  static const _adUnitID = "ca-app-pub-3940256099942544/3986624511";
  final _nativeAdController = NativeAdmobController();

  final String _sourceKey = 'songs';

  ScrollController _scrollController;
  bool _isFetching = true;
  int _currentPage = 1;
  int _adInterval = 5;
  List<FeedItem> _items = [];
  List<Song> _songs = [];

  @override
  void initState() {
    refresh().then((_) => loadSongsIntoAudioPlayer());

    _scrollController = ScrollController();
    _scrollController.addListener(shouldFetch);
    super.initState();
  }

  @override
  void dispose() {
    _nativeAdController.dispose();
    _scrollController.removeListener(shouldFetch);
    _scrollController.dispose();
    super.dispose();
  }

  void shouldFetch() {
    if (_isFetching) return;

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 160 &&
        !_scrollController.position.outOfRange) {
      fetchItems().then((_) => loadSongsIntoAudioPlayer());
    }
  }

  void loadSongsIntoAudioPlayer() {
    final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);
    if (audioPlayer.source == null || audioPlayer.source == _sourceKey)
      audioPlayer.loadPlaylistFromSource(_sourceKey, _songs);
  }

  Future<void> fetchItems() async {
    setState(() {
      _isFetching = true;
    });

    final token = Provider.of<Auth>(context, listen: false).token;

    List<Song> fetchedSongs = [];
    try {
      fetchedSongs = await SongsService.fetchSongs(token, page: _currentPage);
    } catch (err, stack) {
      ErrorReportingService.report(err, stackTrace: stack);
    }

    List<FeedItem> items = [..._items];
    List<Song> songs = [..._songs];
    for (var i = 0; i < fetchedSongs.length; i++) {
      if (i > 0 && i % (_adInterval - 1) == 0) {
        items.add(AdFeedItem(_adUnitID, _nativeAdController));
      }

      items.add(SongFeedItem(fetchedSongs[i], handlePlay));
      songs.add(fetchedSongs[i]);
    }

    setState(() {
      _items = items;
      _songs = songs;
      _currentPage = _currentPage + 1;
      _isFetching = false;
    });
  }

  Future<void> refresh() async {
    setState(() {
      _currentPage = 1;
      _items = [];
      _songs = [];
    });
    await fetchItems();
  }

  Future<void> handlePlay(Song song) async {
    final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);
    if (!audioPlayer.isSourcedFrom(_sourceKey)) {
      await audioPlayer.stop();
      audioPlayer.clearCurrentSong();
      audioPlayer.loadPlaylistFromSource(_sourceKey, _songs);
    }
    await audioPlayer.playOrPause(song);
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
        backgroundColor: LloudTheme.blackLight,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: refresh,
            color: LloudTheme.red,
            backgroundColor: LloudTheme.blackLight,
            child: CustomScrollView(
              semanticChildCount: _songs.length,
              controller: _scrollController,
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  return _items[index].build(context);
                }, childCount: _items.length)),
                if (_isFetching)
                  SliverList(
                      delegate: SliverChildListDelegate([
                    Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(LloudTheme.red),
                      ),
                    )
                  ]))
              ],
            ),
          ),
        ));
  }
}
