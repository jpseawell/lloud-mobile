class Network {
  static const host = 'https://www.lloudapp.com';
  static const wsHost = 'ws://www.lloudapp.com';

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
