class Network {
  static const host = 'http://dev.lloudapp.com';
  static const wsHost = 'ws://dev.lloudapp.com';

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
