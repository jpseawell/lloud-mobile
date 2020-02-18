import 'package:http/http.dart' as http;

// The Data Access Layer is used for
// abstracting away the process of sending &
// retrieving data from the web API.

class DAL {
  final String _apiUrl =
      'http://ec2-18-191-169-184.us-east-2.compute.amazonaws.com:3000/api/v1/';

  final _requestHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json'
  };

  Map<String, String> get headers {
    // If logged in => add auth header
    return _requestHeaders;
  }

  Future<http.Response> fetch(String route) {
    return http.get(this._apiUrl + route, headers: headers);
  }

  Future<http.Response> post(String route, dynamic data) {
    return http.post(this._apiUrl + route, body: data);
  }

  static instance() {
    return new DAL();
  }
}
