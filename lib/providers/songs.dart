import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/util/network.dart';

class Songs with ChangeNotifier {
  List<Song> _songs = [];
  final String authToken;

  Songs(this.authToken);

  List<Song> get songs => [..._songs];

  Future<void> fetchAndSetSongs({int page = 1}) async {
    final url = '${Network.host}/api/v2/songs?page=$page';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['status'] != 'success')
      throw Exception('Songs fetch failed.');

    _songs.addAll(
        Song.fromJsonList(decodedRes['data']['songs'] as List<dynamic>));
    notifyListeners();
  }

  Future<void> resetSongs() async {
    _songs = [];
    await fetchAndSetSongs();
  }
}
