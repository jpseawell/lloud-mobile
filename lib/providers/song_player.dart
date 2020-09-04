import 'package:flutter/cupertino.dart';
import 'package:assets_audio_player/assets_audio_player.dart';

import 'package:lloud_mobile/models/song.dart';

class SongPlayer with ChangeNotifier {
  final _audioPlayer = AssetsAudioPlayer();

  bool _isPlaying = false;
  Song _currentSong;
  Playlist _playList;

  bool get isPlaying => _isPlaying;
  Song get currentSong => _currentSong;

  Playlist get playlist => _playList;
  void set playlist(Playlist playlist) => _playList = playlist;

  Future<void> playSong(Song song) async {
    if (_currentSong.id != song.id) {
      await stopSong();
    }

    try {
      // await _audioPlayer.open(song.toAudio(), showNotification: true);
    } catch (err) {
      // Throw err
      // Stop the audio
    }

    _currentSong = song;
    _isPlaying = true;
    notifyListeners();
  }

  Future<void> stopSong() async {
    _audioPlayer.stop();
    _currentSong = null;
    _isPlaying = false;

    // TODO: Post duration

    notifyListeners();
  }

  Future<void> pauseSong() async {
    _audioPlayer.pause();
    _isPlaying = false;
    notifyListeners();
  }
}
