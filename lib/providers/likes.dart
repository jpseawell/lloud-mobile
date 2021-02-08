import 'package:flutter/material.dart';
import 'package:lloud_mobile/providers/auth.dart';
import 'package:lloud_mobile/services/error_reporting.dart';
import 'package:lloud_mobile/services/likes_service.dart';

/// This class is different from the LikesService.
/// It is focused on fetching and setting data
/// about the history of likes of the authenticated user.
/// (rather than fetching/updating the likes resource in general)
class Likes with ChangeNotifier {
  String authToken;
  int userId;

  Likes(this.authToken, this.userId);

  List<int> _likedSongIds = [];
  int _totalPoints = 0;

  List<int> get likedSongIds => [..._likedSongIds];
  int get totalPoints => _totalPoints;

  Likes update(Auth auth) {
    authToken = auth.token;
    userId = auth.userId;

    (authToken == null || userId == null || userId == 0)
        ? clear()
        : fetchAndSetLikes();

    return this;
  }

  void clear() {
    _likedSongIds = [];
    _totalPoints = 0;
    notifyListeners();
  }

  Future<void> fetchAndSetLikes() async {
    Map<String, dynamic> profile;

    try {
      profile = await LikesService.fetchLikesProfile(authToken, userId);
    } catch (err, stack) {
      ErrorReportingService.report(err, stackTrace: stack);
    }

    _likedSongIds = new List<int>.from(profile['songIds']);
    _totalPoints = profile['totalPoints'];
    notifyListeners();
  }

  Future<void> addLike(int songId) async {
    await LikesService.addLike(authToken, userId, songId);
    _likedSongIds.add(songId);
    notifyListeners();
  }
}
