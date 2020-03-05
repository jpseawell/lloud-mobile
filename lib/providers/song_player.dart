import 'package:flutter/cupertino.dart';
import 'package:audioplayers/audioplayers.dart';

class SongPlayer with ChangeNotifier {
  final AudioPlayer _audioPlayer = AudioPlayer();
  bool _isPlaying = false;
  int _currentSongId = 0;

  bool get isPlaying => _isPlaying;
  int get currentSongId => _currentSongId;

  Future<void> playSong(int songId, String songUrl) async {
    if (this._currentSongId != songId) {
      await stopPlaying();
    }

    int result = await this._audioPlayer.play(songUrl);
    if (result == 1) {
      this._currentSongId = songId;
      _isPlaying = true;
      notifyListeners();
    }
  }

  Future<void> stopPlaying() async {
    int result = await this._audioPlayer.stop();
    if (result == 1) {
      this._currentSongId = 0;
      _isPlaying = false;
    }
    notifyListeners();
  }

  Future<void> pauseSong() async {
    int result = await this._audioPlayer.pause();
    if (result == 1) {
      _isPlaying = false;
      notifyListeners();
    }
  }
}
