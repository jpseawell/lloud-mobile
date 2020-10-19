import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import './auth.dart';

// The Data Access Layer is used for
// abstracting away the process of sending &
// retrieving data from the web API.

class DAL {
  // TODO: Setup environment variables

  // PROD
  // final String _apiUrl =
  //     'http://ec2-18-191-169-184.us-east-2.compute.amazonaws.com:3000/api/v1/';

  //final String _apiUrl = 'https://www.lloudapp.com/api/v1/';

  // DEV - windows
  final String _apiUrl = 'http://10.0.2.2:3333/api/';

  // DEV - mac
  // final String _apiUrl = 'http://davids-mac.local:3333/api/v1/';

  final _requestHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  };

  Future<Map<String, String>> get headers async {
    bool isLoggedIn = await Auth.loggedIn();

    if (isLoggedIn) {
      String token = await Auth.getToken();
      _requestHeaders['Authorization'] = 'Bearer ' + token;
    }

    return _requestHeaders;
  }

  Future<http.Response> fetch(String route) async {
    Map<String, String> hdrs = await headers;
    return http.get(this._apiUrl + route, headers: hdrs);
  }

  Future<http.Response> delete(String route) async {
    Map<String, String> hdrs = await headers;
    return http.delete(this._apiUrl + route, headers: hdrs);
  }

  Future<http.Response> post(String route, dynamic data,
      {bool useAuthHeader = true}) async {
    Map<String, String> hdrs = await headers;
    if (!useAuthHeader) {
      hdrs.remove('Authorization');
    }
    return await http.post(this._apiUrl + route,
        headers: hdrs, body: jsonEncode(data));
  }

  Future<http.Response> postFile(String filename, String route) async {
    var req = http.MultipartRequest('POST', Uri.parse(this._apiUrl + route));

    req.headers['Accept'] = 'application/json';

    if (await Auth.loggedIn()) {
      String token = await Auth.getToken();
      req.headers['Authorization'] = 'Bearer ' + token;
    }

    req.files.add(await http.MultipartFile.fromPath('image', filename,
        contentType: MediaType('image', 'jpg')));

    var streamedRes = await req.send();
    return await http.Response.fromStream(streamedRes);
  }

  Future<http.Response> put(String route, dynamic data) async {
    Map<String, String> hdrs = await headers;
    return await http.put(this._apiUrl + route,
        headers: hdrs, body: jsonEncode(data));
  }

  static instance() {
    return new DAL();
  }
}
