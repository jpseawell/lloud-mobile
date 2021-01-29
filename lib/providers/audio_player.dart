import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/services/error_reporting.dart';
import 'package:lloud_mobile/util/network.dart';

class AudioPlayer with ChangeNotifier {
  final AssetsAudioPlayer _player = AssetsAudioPlayer();
  final String authToken;
  int _index;
  List<Audio> _playlist = [];
  List<Song> _songs = []; // Strictly used for storing & displaying metadata
  String _source;

  AudioPlayer(this.authToken);

  AssetsAudioPlayer get player => _player;
  String get source => _source;

  int get currentSongId {
    if (_index == null) return null;

    return int.parse(_playlist[_index].metas.id);
  }

  Audio get currentAudio {
    if (_index == null) return null;

    return _playlist[_index];
  }

  Song get currentSong {
    if (_index == null) return null;

    return _songs[_index];
  }

  set source(String source) {
    _source = source;
    notifyListeners();
  }

  set playlist(List<Song> songs) {
    _playlist = _convertSongsToAudio(songs);
    _songs = songs;
    notifyListeners();
  }

  void listenForEndOfSong() {
    _player.playlistFinished.listen((finished) {
      if (finished) next();
    });
  }

  void setPlaylistFromNewSource(String source, List<Song> songs) {
    _index = null;
    _source = source;
    _playlist = _convertSongsToAudio(songs);
    _songs = songs;
    notifyListeners();
  }

  Future<void> play(Song song) async {
    await playAtIndex(indexOfSong(song));
  }

  Future<void> playAtIndex(int index) async {
    try {
      final settings = NotificationSettings(
        nextEnabled: true,
        seekBarEnabled: false,
        customNextAction: (player) => next(),
        customPrevAction: (player) => prev(),
        customPlayPauseAction: (player) => toggleCurrentSong(),
      );

      await _player.open(_playlist[index],
          showNotification: true, notificationSettings: settings);
    } catch (err, stack) {
      ErrorReportingService.report(err, stackTrace: stack);
    }

    await _player.play();

    _index = index;
    notifyListeners();
  }

  Future<void> togglePlay(Song song) async {
    if (_player.isBuffering.value) return;

    if (currentSongId == song.id) {
      await toggleCurrentSong();
      return;
    }

    if (currentSongId != null) await stop();
    await play(song);
  }

  Future<void> toggleCurrentSong() async {
    try {
      _player.isPlaying.value ? await _player.pause() : await _player.play();
    } catch (err, stack) {
      print(err);
      ErrorReportingService.report(err, stackTrace: stack);
    }
  }

  Future<void> next() async {
    await stop();
    await playAtIndex(nextIndex());
  }

  Future<void> prev() async {
    await stop();
    await playAtIndex(prevIndex());
  }

  Future<void> stop() async {
    reportPlay();
    await _player.stop();
  }

  Future<void> stopAndDispose() async {
    await stop();
    await _player.dispose();
    _index = null;
    notifyListeners();
  }

  Future<void> reportPlay() async {
    final duration = _player.currentPosition.value;
    final url = '${Network.host}/api/v2/plays';
    final playData = {
      'song_id': currentSongId,
      'duration': duration.toString().substring(0, 8)
    };
    final res = await http.post(url,
        headers: Network.headers(token: authToken),
        body: json.encode(playData));
    Map<String, dynamic> decodedRes = json.decode(res.body);
  }

  int indexOfSong(Song song) => _playlist.indexOf(song.toAudio());
  int nextIndex() {
    if (_index == null) return null;

    int nextIndex = _index + 1;
    if (nextIndex > _playlist.length - 1) nextIndex = 0;

    return nextIndex;
  }

  int prevIndex() {
    if (_index == null) return null;

    int prevIndex = _index - 1;
    if (prevIndex < 0) prevIndex = _playlist.length - 1;

    return prevIndex;
  }

  bool isSourcedFrom(String source) => source == _source;

  List<Audio> _convertSongsToAudio(List<Song> songs) {
    List<Audio> results = [];
    songs.forEach((song) {
      results.add(song.toAudio());
    });
    return results;
  }
}
