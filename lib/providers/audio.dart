import 'package:flutter/material.dart';
import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:http/http.dart';

import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/util/dal.dart';

class AudioProvider with ChangeNotifier {
  final AssetsAudioPlayer _audioPlayer = AssetsAudioPlayer();
  List<Song> _songs = <Song>[];
  int _currentIndex;
  bool _isPlaying = false;
  bool _isOpened = false;
  String _playlistKey;

  AssetsAudioPlayer get audioPlayer => _audioPlayer;
  Playlist get playlist => _audioPlayer.playlist;
  int get currentIndex => _currentIndex;
  Song get currentSong =>
      (_currentIndex == null) ? null : _songs[_currentIndex];
  bool get isPlaying => _isPlaying;
  String get playlistKey => _playlistKey;
  set playlistKey(String key) {
    _playlistKey = key;
    notifyListeners();
  }

  void init(List<Song> songs) {
    _audioPlayer.open(Playlist(audios: _convertSongsToAudio(songs)),
        autoStart: false,
        showNotification: false,
        loopMode: LoopMode.playlist,
        volume: 1.0);

    _audioPlayer.current.listen((Playing playing) {
      if (!_isOpened) {
        return;
      }

      if (playing != null) {
        _currentIndex = playing.index;
      }
      notifyListeners();
    });

    _audioPlayer.playlistAudioFinished.listen((Playing playing) {
      reportPlay(_audioPlayer.currentPosition.value);
    });
  }

  void openPlayer() {
    _isOpened = true;
    notifyListeners();
  }

  void nextSongOrLoop() {
    _audioPlayer.next();
    _isPlaying = true;
    notifyListeners();
  }

  void prevSongOrLoop() {
    /// NOTE:
    /// For some reason _audioPlayer.previous();
    /// isn't working.

    _currentIndex -= 1;
    if (_currentIndex < 0) {
      _currentIndex = (_songs.length - 1);
    }

    findAndPlay(_currentIndex);
    _isPlaying = true;
    notifyListeners();
  }

  void addSongsToPlaylist(List<Song> songs) {
    _songs.addAll(songs);

    if (_audioPlayer.playlist == null) {
      return init(songs);
    }

    _audioPlayer.playlist.addAll(_convertSongsToAudio(songs));

    notifyListeners();
  }

  void clearPlaylist() {
    _songs.clear();
    _audioPlayer.playlist.audios.clear();
    _currentIndex = null;

    notifyListeners();
  }

  void stopAndClearPlaylist() {
    stop();
    clearPlaylist();
  }

  void findAndPlay(int index) {
    if (!_isOpened) {
      openPlayer();
    }

    if (_currentIndex != null) {
      reportPlay(_audioPlayer.currentPosition.value);
    }

    _currentIndex = index;
    _isPlaying = true;

    _audioPlayer.playlistPlayAtIndex(index);

    notifyListeners();
  }

  Future<void> reportPlay(Duration playedDuration) async {
    int playedSongId = _songs[_currentIndex].id;

    dynamic dal = DAL.instance();
    Response res = await dal.post('songs/${playedSongId.toString()}/play',
        {'duration': playedDuration.toString().substring(0, 8)});
  }

  void resume() {
    _isPlaying = true;
    _audioPlayer.play();
    notifyListeners();
  }

  void pause() {
    _isPlaying = false;
    _audioPlayer.pause();
    notifyListeners();
  }

  void stop() {
    _isPlaying = false;
    _audioPlayer.stop();
    notifyListeners();
  }

  List<Audio> _convertSongsToAudio(List<Song> songs) {
    List<Audio> newAudio = <Audio>[];
    songs.forEach((song) {
      newAudio.add(song.toAudio());
    });
    return newAudio;
  }
}
