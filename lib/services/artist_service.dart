import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:lloud_mobile/models/artist.dart';
import 'package:lloud_mobile/models/image_file.dart';
import 'package:lloud_mobile/models/song.dart';
import 'package:lloud_mobile/util/network.dart';

class ArtistService {
  static Future<Map<String, dynamic>> fetchArtistProfile(
      String authToken, int artistId) async {
    final url = '${Network.host}/api/v2/artists/$artistId';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['status'] != 'success')
      throw Exception('Unable to retrieve artist');

    return {
      'artist': Artist.fromJson(decodedRes["data"]["artist"]),
      'likes': decodedRes['data']['likes'],
      'plays': decodedRes['data']['plays']
    };
  }

  static Future<ImageFile> fetchImage(String authToken, int artistId) async {
    final url = '${Network.host}/api/v2/artist/$artistId/image-files';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    return ImageFile.fromJson(decodedRes['data']['imageFile']);
  }

  static Future<List<Song>> fetchSongs(String authToken, int artistId) async {
    final url = '${Network.host}/api/v2/artist/$artistId/songs';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['data'] == null)
      throw Exception('Error: No artist songs found');

    return Song.fromJsonList(decodedRes['data']['songs']);
  }

  static Future<List<dynamic>> fetchSupporters(
      String authToken, int artistId) async {
    final url = '${Network.host}/api/v2/artist/$artistId/supporters';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['data'] == null)
      throw Exception('Error: No supporters found');

    return decodedRes['data']['supporters'];
  }
}
