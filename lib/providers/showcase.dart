import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/models/showcase_item.dart';
import 'package:lloud_mobile/util/network.dart';

class Showcase with ChangeNotifier {
  final String authToken;

  List<ShowcaseItem> _items = [];

  Showcase(this.authToken);

  List<ShowcaseItem> get items => [..._items];

  Future<void> fetchAndSetItems() async {
    final url = '${Network.host}/api/v2/showcase-items';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    _items = ShowcaseItem.fromJsonList(decodedRes["data"]["showcaseItems"]);
    notifyListeners();
  }
}
