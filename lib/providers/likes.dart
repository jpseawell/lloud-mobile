import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/models/portfolio_item.dart';
import 'package:lloud_mobile/util/network.dart';

class Likes with ChangeNotifier {
  List<PortfolioItem> _items = [];
  final String authToken;
  final int userId;

  Likes(this.authToken, this.userId);

  List<PortfolioItem> get items => [..._items];

  Future<void> fetchAndSetLikes({int page = 1, int overrideUserId}) async {
    final uid = overrideUserId == null ? userId : overrideUserId;

    final url = '${Network.host}/api/v2/user/$uid/likes?page=$page';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['status'] != 'success')
      throw Exception('Likes fetch failed.');

    _items.addAll(PortfolioItem.fromJsonList(
        decodedRes['data']['likes'] as List<dynamic>));
    notifyListeners();
  }

  Future<void> resetLikes({int overrideUserId}) async {
    _items = [];
    await fetchAndSetLikes(overrideUserId: overrideUserId);
  }

  Future<void> addLike(int userId, int songId) async {
    final url = '${Network.host}/api/v2/likes';
    final likeData = {'user_id': userId, 'song_id': songId};
    final res = await http.post(url,
        headers: Network.headers(token: authToken),
        body: json.encode(likeData));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (!decodedRes['success']) throw Exception('Add like failed.');
  }
}
