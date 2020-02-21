import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';

import './dal.dart';

// The authorization class is
// used for managing user authentication
// in tandem with the web API.

class Auth {
  static final storage = new FlutterSecureStorage();

  static Future<void> setToken(String idToken) async {
    await storage.write(key: 'id_token', value: idToken);
  }

  static Future<String> getToken() async {
    return await storage.read(key: 'id_token');
  }

  static Future<void> authenticateUser(String email, String passwd) async {
    DAL dal = DAL.instance();

    Map<String, String> userData = {'email': email, 'password': passwd};

    Response res = await dal.post('auth', userData);

    if (res.statusCode == 200) {
      await setToken(json.decode(res.body)['data']);
    } else {
      throw Exception('Failed to authenticate user');
    }
  }

  static Future<bool> loggedIn() async {
    String token = await getToken();

    if (token.isEmpty) {
      return false;
    }

    if (isTokenExpired(token)) {
      return false;
    }

    return true;
  }

  static bool isTokenExpired(token) {
    Map<String, dynamic> parsedJwt = parseJwt(token);

    if (parsedJwt['exp'] < (new DateTime.now().millisecond) / 1000) {
      return true;
    } else {
      return false;
    }
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
