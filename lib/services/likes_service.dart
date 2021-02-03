import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:lloud_mobile/models/portfolio_item.dart';
import 'package:lloud_mobile/util/network.dart';

class LikesService {
  static Future<List<PortfolioItem>> fetchLikes(String authToken, int userId,
      {int page = 1}) async {
    final url = '${Network.host}/api/v2/user/$userId/likes?page=$page';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['status'] != 'success')
      throw Exception('Likes fetch failed.');

    return PortfolioItem.fromJsonList(
        decodedRes['data']['likes'] as List<dynamic>);
  }

  static Future<void> addLike(String authToken, int userId, int songId) async {
    final url = '${Network.host}/api/v2/likes';
    final likeData = {'user_id': userId, 'song_id': songId};
    final res = await http.post(url,
        headers: Network.headers(token: authToken),
        body: json.encode(likeData));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (!decodedRes['success']) throw Exception('Add like failed.');
  }
}
