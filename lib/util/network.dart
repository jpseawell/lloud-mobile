import 'package:flutter_dotenv/flutter_dotenv.dart';

class Network {
  static const wsHost = 'ws://0.0.0.0:3333';

  static get host {
    return env['CLIENT_HOST'];
  }

  static Map<String, String> headers({String token}) {
    Map<String, String> headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    };

    if (token != null) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }
}
