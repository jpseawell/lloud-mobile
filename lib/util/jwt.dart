import 'dart:convert';

class Jwt {
  static Future<bool> isValid(String token) async {
    Map<String, dynamic> parsedJwt;

    if (token == null) {
      return false;
    }

    if (token.isEmpty) {
      return false;
    }

    parsedJwt = parse(token);
    if (!parsedJwt.containsKey('exp')) {
      // await clearToken(); // ??
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

  static Map<String, dynamic> parse(String token) {
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
