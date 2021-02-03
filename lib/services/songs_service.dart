import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/util/network.dart';

class SongsService {
  static Future<List<Song>> fetchSongs(String authToken, {int page = 1}) async {
    final url = '${Network.host}/api/v2/songs?page=$page';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['status'] != 'success')
      throw Exception('Songs fetch failed.');

    return Song.fromJsonList(decodedRes['data']['songs'] as List<dynamic>);
  }
}
