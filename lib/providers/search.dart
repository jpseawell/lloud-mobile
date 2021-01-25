import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:lloud_mobile/util/network.dart';

class Search with ChangeNotifier {
  final String authToken;
  bool _isSearching = false;
  bool _isFetching = false;

  List<dynamic> _artists = [];
  List<dynamic> _users = [];
  List<dynamic> _songs = [];

  set isSearching(bool value) {
    _isSearching = value;
    notifyListeners();
  }

  set isFetching(bool value) {
    _isFetching = value;
    notifyListeners();
  }

  bool get isSearching => _isSearching;
  bool get isFetching => _isFetching;

  List<dynamic> get artists => [..._artists];
  List<dynamic> get users => [..._users];
  List<dynamic> get songs => [..._songs];

  void clear() {
    _isSearching = false;
    _isFetching = false;
    _artists = [];
    _users = [];
    _songs = [];
    notifyListeners();
  }

  void clearResults() {
    _artists = [];
    _users = [];
    _songs = [];
    notifyListeners();
    print('cleared');
  }

  Search(this.authToken);

  Future<void> fetchAndSetSearchResults(String searchTerm) async {
    final url = '${Network.host}/api/v2/search';
    final res = await http.post(url,
        headers: Network.headers(token: authToken),
        body: json.encode({'searchTerm': searchTerm}));
    Map<String, dynamic> decodedRes = json.decode(res.body);

    if (decodedRes['status'] != 'success')
      throw Exception('Search request failed');

    if (decodedRes['data'] == null) {
      return;
    }

    _artists = decodedRes['data']['artists'] ?? [];
    _users = decodedRes['data']['users'] ?? [];
    _songs = decodedRes['data']['songs'] ?? [];

    notifyListeners();
  }
}
