import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/util/network.dart';
import 'package:lloud_mobile/models/store_item.dart';

class StoreItems with ChangeNotifier {
  List<StoreItem> _storeItems = [];
  final String authToken;

  StoreItems(this.authToken);

  List<StoreItem> get items => [..._storeItems];

  Future<void> fetchAndSetStoreItems() async {
    final url = '${Network.host}/api/v2/store-items';
    final res = await http.get(url, headers: Network.headers(token: authToken));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    List<StoreItem> tmp = [];

    decodedRes['data']
        .forEach((storeItem) => tmp.add(StoreItem.fromJson(storeItem)));

    _storeItems = tmp;
    notifyListeners();
  }

  Future<void> purchaseItem(Map<String, dynamic> purchaseDetails) async {
    final url = '${Network.host}/api/v2/store-purchases';
    final res = await http.post(url,
        headers: Network.headers(token: authToken),
        body: json.encode(purchaseDetails));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (!decodedRes['success']) throw Exception('Store item purchase failed');
  }
}
