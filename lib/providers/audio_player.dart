import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/services/error_reporting.dart';
import 'package:lloud_mobile/util/network.dart';

class AudioPlayer with ChangeNotifier {
  final FlutterSoundPlayer _player = FlutterSoundPlayer();
  final StreamController<PlaybackDisposition> _localController =
      StreamController<PlaybackDisposition>.broadcast();

  List<Song> _songs = [];
  int _index;
  Song _currentSong;
  String _source;
  bool _isPlaying = false;
  String authToken;

  FlutterSoundPlayer get player => _player;
  String get source => _source;
  Song get currentSong => _currentSong;
  int get currentSongId => _currentSong == null ? null : _currentSong.id;
  bool get isPlaying => _isPlaying;
  StreamController<PlaybackDisposition> get streamController =>
      _localController;

  set index(int i) {
    _index = i;
    notifyListeners();
  }

  set currentSong(Song s) {
    _currentSong = s;
    notifyListeners();
  }

  set isPlaying(bool b) {
    _isPlaying = b;
    notifyListeners();
  }

  Future<void> init() async {
    await _player
        .openAudioSession(
      withUI: true,
      focus: AudioFocus.requestFocusAndStopOthers,
      category: SessionCategory.playback,
      audioFlags: outputToSpeaker | allowBlueToothA2DP | allowAirPlay,
    )
        .then((_) {
      _player.dispositionStream().listen(_localController.add);
      _player.setSubscriptionDuration(Duration(milliseconds: 100));
    });
  }

  Future<void> dispose() async {
    try {
      _player.closeAudioSession();
    } catch (err, stack) {
      ErrorReportingService.report(err, stackTrace: stack);
    }
  }

  Future<void> play(Song song) async {
    loadSongOrThrow(song);
    isPlaying = true;
    await reportPlay(); // Report the previous play

    _player.startPlayerFromTrack(Song.toTrack(song),
        onPaused: (_) => toggle(),
        defaultPauseResume: false,
        onSkipBackward: () => prev(),
        onSkipForward: () => next(),
        whenFinished: () {
          reportPlay();
          next();
        });
  }

  Future<void> resume() async {
    isPlaying = true;
    await _player.resumePlayer();
  }

  Future<void> playOrPause(Song song) async {
    if (song.id == currentSongId) {
      await toggle();
      return;
    }

    await play(song);
  }

  Future<void> stop() async {
    isPlaying = false;
    await _player.stopPlayer();
  }

  Future<void> pause() async {
    isPlaying = false;
    await _player.pausePlayer();
  }

  Future<void> toggle() async {
    isPlaying ? await pause() : await resume();
  }

  Future<void> next() async {
    if (_index == null)
      throw Exception('Error: Calling next when index is null.');

    int nextIndex = _index + 1;
    if (nextIndex > _songs.length - 1) nextIndex = 0;

    await play(_songs[nextIndex]);
  }

  Future<void> prev() async {
    if (_index == null)
      throw Exception('Error: Calling prev when index is null.');

    int prevIndex = _index - 1;
    if (prevIndex < 0) prevIndex = _songs.length - 1;

    await play(_songs[prevIndex]);
  }

  int indexOfSong(Song song) =>
      _songs.indexWhere((_song) => _song.id == song.id);

  void loadSongOrThrow(Song song) {
    final newIndex = indexOfSong(song);

    if (newIndex == -1)
      throw Exception('Error: Requested song not found in songs list.');

    _index = newIndex;
    _currentSong = song;
    notifyListeners();
  }

  void clearCurrentSong() {
    _index = null;
    _currentSong = null;
    notifyListeners();
  }

  void loadPlaylistFromSource(String source, List<Song> songs) {
    _source = source;
    _songs = songs;
    notifyListeners();
  }

  bool isSourcedFrom(String source) => source == _source;

  Future<void> reportPlay() async {
    if (!_player.isPlaying) return;

    final playback =
        await _localController.stream.firstWhere((packet) => packet != null);

    final url = '${Network.host}/api/v2/plays';
    final playData = {
      'song_id': currentSongId,
      'duration': playback.position.toString().substring(0, 8)
    };
    final res = await http.post(url,
        headers: Network.headers(token: authToken),
        body: json.encode(playData));
    Map<String, dynamic> decodedRes = json.decode(res.body);
  }
}
