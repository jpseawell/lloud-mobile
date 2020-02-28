import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

import './auth.dart';

// The Data Access Layer is used for
// abstracting away the process of sending &
// retrieving data from the web API.

class DAL {
  // final String _apiUrl =
  //     'http://ec2-18-191-169-184.us-east-2.compute.amazonaws.com:3000/api/v1/';

  final String _apiUrl = 'http://192.168.0.8:5000/api/v1/';

  final _requestHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  };

  Future<Map<String, String>> get headers async {
    bool isLoggedIn = await Auth.loggedIn();

    if (isLoggedIn) {
      String token = await Auth.getToken();
      _requestHeaders['x-access-token'] = token;
    }

    return _requestHeaders;
  }

  Future<http.Response> fetch(String route) async {
    Map<String, String> hdrs = await headers;
    return http.get(this._apiUrl + route, headers: hdrs);
  }

  Future<http.Response> post(String route, dynamic data) async {
    Map<String, String> hdrs = await headers;
    return await http.post(this._apiUrl + route,
        headers: hdrs, body: jsonEncode(data));
  }

  static instance() {
    return new DAL();
  }
}
