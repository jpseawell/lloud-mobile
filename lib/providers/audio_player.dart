import 'dart:convert';

import 'package:audiofileplayer/audio_system.dart';
import 'package:audiofileplayer/audiofileplayer.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/services/error_reporting.dart';
import 'package:lloud_mobile/util/helpers.dart';
import 'package:lloud_mobile/util/network.dart';

class AudioPlayer with ChangeNotifier {
  final AudioSystem _system = AudioSystem.instance;

  String _authToken;
  Audio _player;
  List<Song> _songs = [];
  int _index;
  Song _currentSong;
  String _source;
  bool _isLoading = false;
  bool _isPlaying = false;
  double _durationSeconds;
  double _positionSeconds = 0;

  AudioPlayer(this._authToken);

  String get source => _source;
  bool get isLoading => _isLoading;
  bool get isPlaying => _isPlaying;
  Song get currentSong => _currentSong;
  int get currentSongId => _currentSong == null ? null : _currentSong.id;
  double get durationSeconds => _durationSeconds;
  double get positionSeconds => _positionSeconds;

  set isLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  set isPlaying(bool val) {
    _isPlaying = val;
    notifyListeners();
  }

  set durationSeconds(double val) {
    _durationSeconds = val;
    notifyListeners();
  }

  set positionSeconds(double val) {
    _positionSeconds = val;
    notifyListeners();
  }

  AudioPlayer update(Auth auth) {
    _authToken = auth.token;

    return this;
  }

  Future<void> seek(double pos) async {
    await _player.seek(pos);
  }

  Future<void> playOrPause(Song song) async {
    if (song.id == currentSongId) {
      await toggle();
      return;
    }

    await play(song);
  }

  Future<void> play(Song song) async {
    if (_player != null) await stop();

    findAndSetIndex(song);
    load(song);
    isPlaying = true;
    _player.resume(); // Intentionally calling resume instead of play
  }

  Future<void> resume() async {
    isPlaying = true;
    await _player.resume();
  }

  Future<void> pause() async {
    isPlaying = false;
    await _player.pause();
  }

  Future<void> toggle() async {
    isPlaying ? await pause() : await resume();
  }

  Future<void> stop() async {
    if (_player == null) return;

    isPlaying = false;

    try {
      await reportPlay();
    } catch (err, stack) {
      ErrorReportingService.report(err, stackTrace: stack);
    }

    await _player.pause();
    await _player.dispose();
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

  void findAndSetIndex(Song song) {
    final index = indexOfSong(song);
    if (index == -1)
      throw Exception('Error: Requested song not found in songs list.');
    _index = index;
    notifyListeners();
  }

  int indexOfSong(Song song) => _songs.indexWhere((s) => s.id == song.id);

  void clear() {
    isLoading = false;
    isPlaying = false;
    _currentSong = null;
    _index = null;
    durationSeconds = null;
    positionSeconds = 0;
  }

  void load(Song song) {
    isLoading = true;
    _currentSong = song;
    _player = Audio.loadFromRemoteUrl(song.audioUrl,
        looping: true,
        playInBackground: true,
        onDuration: (double dur) {
          _handleSongLoad(song);
          durationSeconds = dur;
        },
        onPosition: (double pos) => positionSeconds = pos,
        onComplete: () => _handleSongComplete(),
        onError: (String message) => _handleSongLoadError(message));
  }

  Future<void> _handleSongLoad(Song song) async {
    isLoading = false;
    _system.setMetadata(await getMetaData(song));
  }

  void _handleSongComplete() {
    next();
  }

  Future<void> reportPlay() async {
    final playback = Duration(seconds: positionSeconds.round());
    if (playback == Duration.zero) return;

    if (_authToken == null)
      throw Exception('Error: No auth token found when reporting audio play');

    final url = '${Network.host}/api/v2/plays';
    final playData = {
      'song_id': currentSongId,
      'duration': playback.toString().substring(0, 8)
    };
    await http.post(url,
        headers: Network.headers(token: _authToken),
        body: json.encode(playData));
  }

  void _handleSongLoadError(String message) {
    _index = null;
    _currentSong = null;
    _isPlaying = false;
    _isLoading = false;

    _player.dispose();
    _player = null;
    notifyListeners();

    ErrorReportingService.report(Exception(message));
  }

  Future<AudioMetadata> getMetaData(Song song) async {
    final albumArt = await Helpers.getBytesFromNetworkImg(song.imageUrl);
    return AudioMetadata(
        id: '${song.id}',
        title: song.title,
        artist: song.artistName,
        artBytes: albumArt,
        durationSeconds: durationSeconds);
  }

  void _mediaEventListener(MediaEvent event) {
    final MediaActionType type = event.type;

    switch (type) {
      case MediaActionType.play:
        resume();
        _system.setPlaybackState(true, event.seekToPositionSeconds);
        break;
      case MediaActionType.playPause:
        pause();
        _system.setPlaybackState(false, event.seekToPositionSeconds);
        break;
      case MediaActionType.next:
        next();
        _system.setPlaybackState(true, event.seekToPositionSeconds);
        break;
      case MediaActionType.previous:
        prev();
        _system.setPlaybackState(true, event.seekToPositionSeconds);
        break;
      case MediaActionType.seekTo:
        seek(event.seekToPositionSeconds);
        _system.setPlaybackState(true, event.seekToPositionSeconds);
        break;
      default:
        ErrorReportingService.report(
            Exception('Error: Unknown MediaActionType emitted'));
    }
  }

  void init() {
    _system.setIosAudioCategory(IosAudioCategory.playback);
    _system.addMediaEventListener(_mediaEventListener);

    _system.setSupportedMediaActions(<MediaActionType>{
      MediaActionType.playPause,
      MediaActionType.play,
      MediaActionType.next,
      MediaActionType.previous,
      MediaActionType.seekTo,
    });
  }

  @override
  void dispose() {
    _system.removeMediaEventListener(_mediaEventListener);
    _system.stopBackgroundDisplay();
    clear();
    if (_player != null) {
      _player.pause();
      _player.dispose();
    }
    super.dispose();
  }

  bool isSourcedFrom(String source) => source == _source;

  void loadPlaylistFromSource(String source, List<Song> songs) {
    _source = source;
    _songs = songs;
    notifyListeners();
  }
}
