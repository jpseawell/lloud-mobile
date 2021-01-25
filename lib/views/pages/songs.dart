import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_native_admob/native_admob_controller.dart';
import 'package:provider/provider.dart';

import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/views/components/ad.dart';
import 'package:lloud_mobile/providers/audio_player.dart';
import 'package:lloud_mobile/providers/songs.dart';
import 'package:lloud_mobile/views/components/song_widget.dart';
import 'package:lloud_mobile/config/lloud_theme.dart';

class SongsPage extends StatefulWidget {
  @override
  _SongsPageState createState() => _SongsPageState();
}

class _SongsPageState extends State<SongsPage> {
  // TODO: Move this to global
  static const _adUnitID = "ca-app-pub-3940256099942544/3986624511";
  final _nativeAdController = NativeAdmobController();
  final int _adInterval = 5;

  final String _sourceKey = 'songs';
  ScrollController _scrollController;
  bool _isFetching = true;
  int _currentPage = 1;

  int adjustedIndex(index) => index - (index / _adInterval).floor();
  int adjustedLength(length) => length + (length / _adInterval).floor();

  @override
  void initState() {
    Provider.of<Songs>(context, listen: false).resetSongs().then((value) {
      final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);
      if (audioPlayer.source == null) {
        final songs = Provider.of<Songs>(context, listen: false).songs;
        audioPlayer.setPlaylistFromNewSource(_sourceKey, songs);
      }

      setState(() {
        _isFetching = false;
      });
    }).catchError((err) => print(err.toString()));
    _scrollController = ScrollController();
    _scrollController.addListener(shouldFetch);
    super.initState();
  }

  @override
  void dispose() {
    _nativeAdController.dispose();
    super.dispose();
  }

  void shouldFetch() {
    if (_isFetching) return;

    if (_scrollController.offset >=
            _scrollController.position.maxScrollExtent - 160 &&
        !_scrollController.position.outOfRange) {
      fetchSongs();
    }
  }

  Future<void> fetchSongs() async {
    setState(() {
      _isFetching = true;
      _currentPage = _currentPage + 1;
    });

    final songProvider = Provider.of<Songs>(context, listen: false);
    final audioProvider = Provider.of<AudioPlayer>(context, listen: false);
    await songProvider.fetchAndSetSongs(page: _currentPage);
    if (audioProvider.isSourcedFrom(_sourceKey)) {
      audioProvider.playlist = songProvider.songs;
    }
    setState(() {
      _isFetching = false;
    });
  }

  Future<void> _refresh() async {
    setState(() {
      _isFetching = true;
    });

    await Provider.of<Songs>(context, listen: false).resetSongs();

    setState(() {
      _isFetching = false;
      _currentPage = 1;
    });
  }

  Future<void> handlePlay(Song song) async {
    final audioPlayer = Provider.of<AudioPlayer>(context, listen: false);
    if (!audioPlayer.isSourcedFrom(_sourceKey)) {
      final songs = Provider.of<Songs>(context, listen: false).songs;
      audioPlayer.setPlaylistFromNewSource(_sourceKey, songs);
    }
    await audioPlayer.togglePlay(song);
  }

  @override
  Widget build(BuildContext ctx) {
    final songs = Provider.of<Songs>(context).songs;
    return Scaffold(
        backgroundColor: LloudTheme.blackLight,
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refresh,
            color: LloudTheme.red,
            backgroundColor: LloudTheme.blackLight,
            child: CustomScrollView(
              semanticChildCount: songs.length,
              controller: _scrollController,
              slivers: [
                SliverList(
                    delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                  if ((index + 1) % _adInterval == 0) {
                    _nativeAdController.reloadAd(forceRefresh: true);
                    return Ad(
                      adUnitID: _adUnitID,
                      controller: _nativeAdController,
                    );
                  }
                  return SongWidget(
                      song: songs[adjustedIndex(index)], onPlay: handlePlay);
                }, semanticIndexCallback: (Widget widget, int localIndex) {
                  if ((localIndex + 1) % _adInterval == 0) return null;
                  return adjustedIndex(localIndex);
                }, childCount: adjustedLength(songs.length))),
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
