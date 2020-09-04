import 'dart:convert';

import './dal.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import 'package:lloud_mobile/models/user.dart';

// The authorization class is
// used for managing user authentication
// in tandem with the web API.

class Auth {
  static final storage = new FlutterSecureStorage();

  static Future<void> setToken(String idToken) async {
    await storage.write(key: 'id_token', value: idToken);
  }

  static Future<void> clearToken() async {
    await storage.delete(key: 'id_token');
  }

  static Future<String> getToken() async {
    return await storage.read(key: 'id_token');
  }

  static Future<void> authenticateUser(String email, String passwd) async {
    DAL dal = DAL.instance();

    Map<String, String> userData = {'email': email, 'password': passwd};

    Response res = await dal.post('login', userData, useAuthHeader: false);
    if (res.statusCode == 200) {
      await setToken(json.decode(res.body)['token']);
    } else {
      throw Exception('Failed to authenticate user');
    }
  }

  static Future<User> authenticateAndFetchUser(
      String email, String password) async {
    await authenticateUser(email, password);
    bool isLoggedIn = await loggedIn();

    if (isLoggedIn) {
      final response = await DAL.instance().fetch('me');
      Map<String, dynamic> decodedResponse = json.decode(response.body);

      return User.fromJson(decodedResponse['data']);
    } else {
      throw Exception('Failed to authenticate user');
    }
  }

  static Future<bool> loggedIn() async {
    String token = await getToken();
    Map<String, dynamic> parsedJwt;

    if (token == null) {
      return false;
    }

    if (token.isEmpty) {
      return false;
    }

    parsedJwt = parseJwt(token);
    if (!parsedJwt.containsKey('exp')) {
      await clearToken();
      return false;
    }

    if (isTokenExpired(parsedJwt)) {
      return false;
    }

    return true;
  }

  static bool isTokenExpired(parsedJwt) {
    int millisecondsSinceEpoch = parsedJwt['exp'] * 1000;
    DateTime expDate =
        new DateTime.fromMillisecondsSinceEpoch(millisecondsSinceEpoch);
    DateTime now = new DateTime.now();

    return now.toUtc().isAfter(expDate);
  }

  // TODO: Could probably be broken out into a separate class
  static Map<String, dynamic> parseJwt(String token) {
    final parts = token.split('.');
    if (parts.length != 3) {
      throw Exception('invalid token');
    }

    final payload = _decodeBase64(parts[1]);
    final payloadMap = json.decode(payload);
    if (payloadMap is! Map<String, dynamic>) {
      throw Exception('invalid payload');
    }

    return payloadMap;
  }

  static String _decodeBase64(String str) {
    String output = str.replaceAll('-', '+').replaceAll('_', '/');

    switch (output.length % 4) {
      case 0:
        break;
      case 2:
        output += '==';
        break;
      case 3:
        output += '=';
        break;
      default:
        throw Exception('Illegal base64url string!"');
    }

    return utf8.decode(base64Url.decode(output));
  }
}
